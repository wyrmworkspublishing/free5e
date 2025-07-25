#!/usr/bin/env bash

set -euo pipefail

git config --global --add safe.directory $PWD

# Load .env file, copied from https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
set -a && source $(pwd)/.env && set +a

function clean_up_generated() {
  # Cleanup old generated files, if the exist
  rm -rf "${GENERATED_FILES_TARGET_DIR}"
  for bak in $(find . -name '*.adoc.bak'); do
    rm $bak
  done
  for adoc in $(find . -name '*.adoc'); do
    rm $adoc
  done
}

# Define a function for converting Markdown to AsciiDoc
function convert_markdown_to_asciidoc {
  echo "Converting all Markdown files in $(pwd) to AsciiDoc..."
  book_name="${PWD##*/}"
  adoc_basedir="../../${GENERATED_FILES_TARGET_DIR}/${language}/adoc/${book_name}"

  for md in $(find . -name '*.md'); do
    md_filename="${md##*/}"
    md_filepath="$(dirname -- $md)"
    adoc_filepath="${adoc_basedir}/${md_filepath#./}"
    adoc_filename="${md_filename%.md}.adoc"
    mkdir -p "${adoc_filepath}"

    echo "Converting ${md_filename} to ${adoc_filepath}/${adoc_filename}..."
    kramdoc \
      -a author="Wyrmworks Publishing"  \
      -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
      -a doctype=book \
      -a icons=font \
      -a lang=$language \
      -a partnums \
      -a reproducible \
      -a revdate="$(LANG=$language git log -1 --pretty="format:%cd" --date=format:"${!DATE_FORMAT}" .)" \
      -a sectnums \
      -a sectnumelevels=1 \
      -a stem \
      -a table-stripes=even \
      -a toc \
      -a toclevels=4 \
      --auto-ids \
      --auto-id-prefix="${md_filename%.md}_" \
      --auto-id-separator="_" \
      -o "${adoc_filepath}/${adoc_filename}" \
      $md
  done
}

function convert_asciidoc_to_html {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  ADOC_BASE_FILE_DIR="$(dirname -- ${MD_BASE_FILE#*/})"
  ADOC_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.adoc"
  HTML_BASE_FILE_DIR="../html/${ADOC_BASE_FILE_DIR}"
  HTML_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.html"

  adoc_filepath="$(pwd)/${ADOC_BASE_FILE_DIR}/${ADOC_BASE_FILE_NAME}"
  html_filepath="$(pwd)/${HTML_BASE_FILE_DIR}/${HTML_BASE_FILE_NAME}"
  css_filesdir="$(pwd)/${HTML_BASE_FILE_DIR}/css"
  fonts_filesdir="$(pwd)/${HTML_BASE_FILE_DIR}/fonts"

  echo "Converting ${adoc_filepath} to ${html_filepath}..."

  mkdir -p "${HTML_BASE_FILE_DIR}"
  cp -r ../../../css "${css_filesdir}"
  cp -r ../../../assets/fonts "${fonts_filesdir}"

  # Compile the SCSS file to a CSS file
  pushd "${css_filesdir}"
  rm free5e.css* && echo "Old CSS deleted" || echo "No old CSS found"
  sass free5e.scss free5e.css
  popd

  asciidoctor \
      -b html \
      -a fontsdir="${fonts_filesdir}" \
      -a stylesdir="${css_filesdir}" \
      -a stylesheet=free5e.css \
      -a toc=left \
      "${adoc_filepath}" \
      -o "${html_filepath}"
}

function convert_asciidoc_to_pdf {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  ADOC_BASE_FILE_DIR="$(dirname -- ${MD_BASE_FILE#*/})"
  ADOC_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.adoc"
  PDF_BASE_FILE_DIR="../pdf/"
  PDF_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.pdf"

  adoc_filepath="$(pwd)/${ADOC_BASE_FILE_DIR}/${ADOC_BASE_FILE_NAME}"
  pdf_filepath="$(pwd)/${PDF_BASE_FILE_DIR}/${PDF_BASE_FILE_NAME}"

  mkdir -p "${PDF_BASE_FILE_DIR}"

  asciidoctor-pdf \
      -a pdf-fontsdir="GEM_FONTS_DIR;$FONTS_BASE_DIR" \
      -a pdf-themesdir="$MD_BASE_DIR/themes" \
      -a pdf-theme=pdf \
      "${adoc_filepath}" \
      -o "${pdf_filepath}"
}

function convert_asciidoc_to_epub {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  ADOC_BASE_FILE_DIR="$(dirname -- ${MD_BASE_FILE#*/})"
  ADOC_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.adoc"
  EPUB_BASE_FILE_DIR="../epub/"
  EPUB_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.epub"

  adoc_filepath="$(pwd)/${ADOC_BASE_FILE_DIR}/${ADOC_BASE_FILE_NAME}"
  epub_filepath="$(pwd)/${EPUB_BASE_FILE_DIR}/${EPUB_BASE_FILE_NAME}"

  mkdir -p "${EPUB_BASE_FILE_DIR}"

  asciidoctor-epub3 \
      "${adoc_filepath}" \
      -o "${epub_filepath}"
}

function convert_asciidoc_to_docbook {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  ADOC_BASE_FILE_DIR="$(dirname -- ${MD_BASE_FILE#*/})"
  ADOC_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.adoc"
  DOCBOOK_BASE_FILE_DIR="../docbook/"
  DOCBOOK_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.xml"

  adoc_filepath="$(pwd)/${ADOC_BASE_FILE_DIR}/${ADOC_BASE_FILE_NAME}"
  docbook_filepath="$(pwd)/${DOCBOOK_BASE_FILE_DIR}/${DOCBOOK_BASE_FILE_NAME}"

  mkdir -p "${DOCBOOK_BASE_FILE_DIR}"

  asciidoctor \
      -b docbook \
      "${adoc_filepath}" \
      -o "${docbook_filepath}"
}

function convert_docbook_to_docx {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  DOCBOOK_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.xml"
  DOCX_BASE_FILE_DIR="../docx/"
  DOCX_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.docx"

  docbook_filepath="$(pwd)/${DOCBOOK_BASE_FILE_NAME}"
  docx_filepath="$(pwd)/${DOCX_BASE_FILE_DIR}/${DOCX_BASE_FILE_NAME}"

  mkdir -p "${DOCX_BASE_FILE_DIR}"

  pandoc \
      --from docbook \
      --to docx \
      --output "${docx_filepath}" \
      "${docbook_filepath}"
}

function convert_docbook_to_odt {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  DOCBOOK_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.xml"
  ODT_BASE_FILE_DIR="../odt/"
  ODT_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.odt"

  docbook_filepath="$(pwd)/${DOCBOOK_BASE_FILE_NAME}"
  odt_filepath="$(pwd)/${ODT_BASE_FILE_DIR}/${ODT_BASE_FILE_NAME}"

  mkdir -p "${ODT_BASE_FILE_DIR}"

  pandoc \
      --from docbook \
      --to odt \
      --output "${odt_filepath}" \
      "${docbook_filepath}"
}

function convert_docbook_to_latex {
  MD_BASE_FILE_NAME="${MD_BASE_FILE##*/}"
  DOCBOOK_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.xml"
  LATEX_BASE_FILE_DIR="../latex/"
  LATEX_BASE_FILE_NAME="${MD_BASE_FILE_NAME%.md}.tex"

  docbook_filepath="$(pwd)/${DOCBOOK_BASE_FILE_NAME}"
  latex_filepath="$(pwd)/${LATEX_BASE_FILE_DIR}/${LATEX_BASE_FILE_NAME}"

  mkdir -p "${LATEX_BASE_FILE_DIR}"

  pandoc \
      --from docbook \
      --to latex \
      --output "${latex_filepath}" \
      "${docbook_filepath}"
}

clean_up_generated

# Check the languages to be read
IFS=', ' read -r -a languages <<< "${LANGUAGES_TO_RENDER}"

# Now convert the books in all laguages from the LANGUAGES_TO_RENDER environment variable (as defined in the .env file)
for language in "${languages[@]}"; do
  echo "Rendering of the ${language} files requested."
  mkdir -p "${GENERATED_FILES_TARGET_DIR}/${language}"
  echo "About to generate files to ${GENERATED_FILES_TARGET_DIR}/${language}..."
  
  DATE_FORMAT=$(echo "DATE_FORMAT_${language}" | tr - _)

  FONTS_BASE_DIR="$(pwd)/assets/fonts"

  # Generate the player book files
  BASEFILE_PLAYER_BOOK=$(echo "BASEFILE_PLAYER_BOOK_${language}" | tr - _)
  echo "Converting the ${language} player book Markdown files to AsciiDoc, starting with ${!BASEFILE_PLAYER_BOOK}..."
  pushd $(dirname -- "${!BASEFILE_PLAYER_BOOK}")
  convert_markdown_to_asciidoc
  popd

  # Generate the conductor book AsciiDoc files
  BASEFILE_CONDUCTOR_BOOK=$(echo "BASEFILE_CONDUCTOR_BOOK_${language}" | tr - _)
  echo "Converting the ${language} conductor book Markdown files to AsciiDoc, starting with ${!BASEFILE_CONDUCTOR_BOOK}..."
  pushd $(dirname -- "${!BASEFILE_CONDUCTOR_BOOK}")
  convert_markdown_to_asciidoc
  popd

  # Generate the conductor book AsciiDoc files
  BASEFILE_MONSTER_BOOK=$(echo "BASEFILE_MONSTER_BOOK_${language}" | tr - _)
  echo "Converting the ${language} monster book Markdown files to AsciiDoc, starting with ${!BASEFILE_MONSTER_BOOK}..."
  pushd $(dirname -- "${!BASEFILE_MONSTER_BOOK}")
  convert_markdown_to_asciidoc
  popd

  echo "Generated the following AsciiDoc files:"
  pushd "${GENERATED_FILES_TARGET_DIR}/${language}"
  tree

  # In the newly generated AsciiDoc files, replace links with includes
  for adoc in $(find . -name '*.adoc'); do
    sed -i'.bak' -e 's/^xref:\(.*\).adoc\[.*\]/include::\1.adoc[]/g' $adoc
  done

  # Now make sure that the tables look decent
  for adoc in $(find . -name '*.adoc'); do
    sed -i'.bak' -e 's/^\[cols/\[%autowidth,width=100%\]\n\[cols/g' $adoc
  done
  popd

  # Generate HTML, PDF, EPUB3, and DocBook formats for the books
  MD_BASE_DIR="$(pwd)/$(dirname -- ${!BASEFILE_PLAYER_BOOK})"
  pushd "generated/${language}/adoc"
  MD_BASE_FILE="${!BASEFILE_PLAYER_BOOK}"
  convert_asciidoc_to_html
  convert_asciidoc_to_pdf
  convert_asciidoc_to_epub
  convert_asciidoc_to_docbook
  popd

  MD_BASE_DIR="$(pwd)/$(dirname -- ${!BASEFILE_CONDUCTOR_BOOK})"
  pushd "generated/${language}/adoc"
  echo "Currently in $(pwd)..."
  MD_BASE_FILE="${!BASEFILE_CONDUCTOR_BOOK}"
  convert_asciidoc_to_html
  convert_asciidoc_to_pdf
  convert_asciidoc_to_epub
  convert_asciidoc_to_docbook
  popd

  MD_BASE_DIR="$(pwd)/$(dirname -- ${!BASEFILE_MONSTER_BOOK})"
  pushd "generated/${language}/adoc"
  MD_BASE_FILE="${!BASEFILE_MONSTER_BOOK}"
  convert_asciidoc_to_html
  convert_asciidoc_to_pdf
  convert_asciidoc_to_epub
  convert_asciidoc_to_docbook
  popd

  # Generate DOCX, ODT, and LaTeX files formats for the books
  MD_BASE_DIR="$(pwd)/$(dirname -- $BASEFILE_PLAYER_BOOK)"
  pushd "generated/${language}/docbook"
  MD_BASE_FILE="${!BASEFILE_PLAYER_BOOK}"
  convert_docbook_to_docx
  convert_docbook_to_odt
  convert_docbook_to_latex
  popd

  MD_BASE_DIR="$(pwd)/$(dirname -- $BASEFILE_CONDUCTOR_BOOK)"
  pushd "generated/${language}/docbook"
  MD_BASE_FILE="${!BASEFILE_CONDUCTOR_BOOK}"
  convert_docbook_to_docx
  convert_docbook_to_odt
  convert_docbook_to_latex
  popd

  MD_BASE_DIR="$(pwd)/$(dirname -- $BASEFILE_MONSTER_BOOK)"
  pushd "generated/${language}/docbook"
  MD_BASE_FILE="${!BASEFILE_MONSTER_BOOK}"
  convert_docbook_to_docx
  convert_docbook_to_odt
  convert_docbook_to_latex
  popd
done

# Remove temporary and backup files
pushd generated
for bak in $(find . -name '*.bak'); do
  rm $bak
done
popd

echo "Completed generating files"
