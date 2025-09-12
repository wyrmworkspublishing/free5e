#!/usr/bin/env bash

set -euo pipefail

function convert_asciidoc_to_html {
  echo "Converting AsciiDoc files from ${ADOC_SOURCE_DIR} to HTML..."
  
  ADOC_MAIN_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
  HTML_TARGET_FILE="${HTML_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.html"

  echo "Converting ${ADOC_MAIN_FILE} to ${HTML_TARGET_FILE}..."

  # Compile the SCSS file to a CSS file
  pushd "${CSS_DIR}"
  rm free5e.css* && echo "Old CSS deleted" || echo "No old CSS found"
  sass free5e.scss free5e.css
  popd

  asciidoctor \
      -b html \
      -a favicon="assets/images/favicon.png" \
      -a fontsdir="${FONTS_BASE_DIR}" \
      -a stylesdir="${CSS_DIR}" \
      -a stylesheet=free5e.css \
      -a toc=left \
      -a toclevels=3 \
      "${ADOC_MAIN_FILE}" \
      -o "${HTML_TARGET_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
HTML_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/html"
mkdir -p "${HTML_TARGET_DIR}"

# Create a symbolic link to the assets directory, so that we can include all assets in future generated files
ASSETS_DIR="$(pwd)/assets"
ln -s "${ASSETS_DIR}" "${HTML_TARGET_DIR}" || echo "assets link already exists"

FONTS_BASE_DIR="${HTML_TARGET_DIR}/fonts"

CSS_DIR="${HTML_TARGET_DIR}/css"
cp -r "$(pwd)/css" "${HTML_TARGET_DIR}"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to an HTML file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
convert_asciidoc_to_html
popd
