#!/usr/bin/env bash

set -euo pipefail

git config --global --add safe.directory $PWD

# Load .env file, copied from https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
set -a && source $(pwd)/.env && set +a

# Cleanup old generated files, if the exist
rm -rf "${GENERATED_FILES_TARGET_DIR}"
for bak in $(find . -name '*.adoc.bak'); do
  rm $bak
done
for adoc in $(find . -name '*.adoc'); do
  rm $adoc
done

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
      -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
      -a doctype=book \
      -a icons=font \
      -a lang=$language \
      -a partnums \
      -a reproducible \
      -a revdate="$(git log -1 --pretty="format:%cs" $md)" \
      -a sectnums \
      -a sectnumelevels=1 \
      -a stem \
      -a table-stripes=even \
      -a toc \
      -a toclevels=4 \
      --auto-ids \
      --auto-id-prefix="${md_filename%.md}_" \
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

  echo "Converting ${adoc_filepath} to ${html_filepath}..."

  mkdir -p "${HTML_BASE_FILE_DIR}"
  cp -r ../../../css "${css_filesdir}"

  asciidoctor \
      -b html \
      -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
      -a doctype=book \
      -a icons=font \
      -a lang=$language \
      -a partnums \
      -a reproducible \
      -a revdate="$(git log -1 --pretty="format:%cs" .)" \
      -a sectnums \
      -a sectnumelevels=1 \
      -a stylesdir="${css_filesdir}" \
      -a stylesheet=adoc-golo.css \
      -a table-stripes=even \
      -a toc=left \
      -a toclevels=4 \
      "${adoc_filepath}" \
      -o "${html_filepath}"
}

# Check the languages to be read
IFS=', ' read -r -a languages <<< "${LANGUAGES_TO_RENDER}"

# Now convert the books in all laguages from the LANGUAGES_TO_RENDER environment variable (as defined in the .env file)
for language in "${languages[@]}"; do
  echo "Rendering of the ${language} files requested."
  mkdir -p "${GENERATED_FILES_TARGET_DIR}/${language}"
  echo "About to generate files to ${GENERATED_FILES_TARGET_DIR}/${language}..."
  
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
  popd

  pushd "generated/${language}/adoc"
  echo "Currently in $(pwd)..."

  # Generate HTML formats for the books
  MD_BASE_FILE="${!BASEFILE_PLAYER_BOOK}"
  convert_asciidoc_to_html

  MD_BASE_FILE="${!BASEFILE_CONDUCTOR_BOOK}"
  convert_asciidoc_to_html

  MD_BASE_FILE="${!BASEFILE_MONSTER_BOOK}"
  convert_asciidoc_to_html

  popd
done

# Remove temporary and backup files
pushd generated
for bak in $(find . -name '*.bak'); do
  rm $bak
done
popd
