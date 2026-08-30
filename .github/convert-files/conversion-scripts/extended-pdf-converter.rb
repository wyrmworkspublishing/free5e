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

  def convert_section sect, opts = nil
    return super unless (float_box = @float_box ||= nil)
    indent(float_box[:left] - bounds.left, bounds.width - float_box[:right]) { super }
    @float_box = nil unless page_number == float_box[:page] && cursor > float_box[:bottom]
  end

end