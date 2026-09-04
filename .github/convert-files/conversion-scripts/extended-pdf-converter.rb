# Based on https://docs.asciidoctor.org/pdf-converter/latest/extend/use-cases/#wrap-code-blocks-around-image
class ExtendedPDFConverter < (Asciidoctor::Converter.for 'pdf')
  register_for 'pdf'

  def supports_float_wrapping? node
    # This must include both ulist and olist, both of which defer to the convert_list method.
    %i(paragraph ulist olist section).include? node.context
  end

  # Overriding the convert_list method, described at https://www.rubydoc.info/gems/asciidoctor-pdf/Asciidoctor/PDF/Converter#convert_list-instance_method
  def convert_list node
    return super unless (float_box = @float_box ||= nil)
    indent(float_box[:left] - bounds.left, bounds.width - float_box[:right]) { super }
    @float_box = nil unless page_number == float_box[:page] && cursor > float_box[:bottom]
  end

  # Most of this is taken directly from https://github.com/asciidoctor/asciidoctor-pdf/blob/v2.3.24/lib/asciidoctor/pdf/converter.rb#L636
  def convert_section sect, _opts = {}
    if (sectname = sect.sectname) == 'abstract'
      # HACK: cheat a bit to hide this section from TOC; TOC should filter these sections
      sect.context = :open
      return convert_abstract sect
    elsif (index_section = sectname == 'index') && @index.empty?
      # override numbered_title to hide entry from TOC
      sect.define_singleton_method :numbered_title, ->(*) { '' }
      return
    end
    title = sect.numbered_title formal: true
    sep = (sect.attr 'separator') || (sect.document.attr 'title-separator') || ''
    if !sep.empty? && (title.include? (sep = %(#{sep} )))
      title, _, subtitle = title.rpartition sep
      title = %(#{title}\n<em class="subtitle">#{subtitle}</em>)
    end
    hlevel = sect.level.next
    text_align = (@theme[%(heading_h#{hlevel}_text_align)] || @theme.heading_text_align || @base_text_align).to_sym
    chapterlike = !(part = sectname == 'part') && (sectname == 'chapter' || (sect.document.doctype == 'book' && sect.level == 1))
    hidden = sect.option? 'notitle'
    hopts = { align: text_align, level: hlevel, part: part, chapterlike: chapterlike, outdent: !(part || chapterlike) }
    if part
      if @theme.heading_part_break_before == 'always'
        started_new = true
        start_new_part sect
      end
    elsif chapterlike
      if (@theme.heading_chapter_break_before == 'always' &&
        !(@theme.heading_part_break_after == 'avoid' && sect.first_section_of_part?)) ||
        (@theme.heading_part_break_after == 'always' && sect.first_section_of_part?)
        started_new = true
        start_new_chapter sect
      end
    end

    #################################################################
    # The modifications to handle floats differently start here.    #
    #                                                               #
    # A float from the previous page must not survive a page break. #
    if started_new
      @float_box = nil
    end

    float_box = @float_box ||= nil

    # Discard a stale float. The converter considers the float active
    # only while we're on the page on which it was created and above
    # the bottom of the float.
    if float_box && (page_number != float_box[:page] || cursor <= float_box[:bottom])
      @float_box = float_box = nil
    end

    unless hidden || started_new || at_page_top?
      if float_box
        indent(float_box[:left] - bounds.left, bounds.width - float_box[:right]) do
          arrange_heading sect, title, hopts
        end

        # arrange_heading may have advanced to another page.
        if page_number != float_box[:page] || cursor <= float_box[:bottom]
          @float_box = float_box = nil
        end
      else
        arrange_heading sect, title, hopts
      end
    end
    # This is the end of the float modifications themselves.                            #
    # More changes have to be made further down to handle the changes in titles though. #
    #####################################################################################

    # QUESTION: should we store pdf-page-start, pdf-anchor &
    # pdf-destination in internal map?
    sect.set_attr 'pdf-page-start', (start_pgnum = page_number)
    # QUESTION: should we just assign the section this generated id?
    # NOTE: section must have pdf-anchor in order to be listed in the TOC
    sect.set_attr 'pdf-anchor', (sect_anchor = derive_anchor_from_id sect.id, %(#{start_pgnum}-#{y.ceil}))
    add_dest_for_block sect, id: sect_anchor, y: (at_page_top? ? page_height : nil)

    #################################################################################
    # This logic was copied, but put into a proc (a passable block of logic).       #
    # Ink (= render) the heading using the reduced width while the float is active. #
    ink_heading = proc do
      theme_font :heading, level: hlevel do
        if part
          ink_part_title sect, title, hopts
        elsif chapterlike
          ink_chapter_title sect, title, hopts
        else
          ink_general_heading sect, title, hopts
        end
      end
    end

    unless hidden
      if float_box
        indent(float_box[:left] - bounds.left, bounds.width - float_box[:right]) do
          ink_heading.call
        end

        # The heading itself may have carried us below the floated image.
        if page_number != float_box[:page] || cursor <= float_box[:bottom]
          @float_box = float_box = nil
        end
      else
        ink_heading.call
      end
    end
    # This is the end of the inking modifications for headers. #
    ############################################################

    # IMPORTANT: Don't wrap traverse in indent().
    #
    # Paragraphs, lists, etc. now see @float_box themselves and can
    # perform their own float-aware layout. Wrapping this traversal
    # would double-indent those blocks.
    if index_section
      outdent_section { convert_index_section sect }
    else
      traverse sect
    end
    outdent_section { ink_footnotes sect } if chapterlike
    sect.set_attr 'pdf-page-end', page_number
  end

end