#!/usr/bin/env bash

set -euo pipefail

source "$(dirname $0)/download-images.sh"

function convert_asciidoc_to_pdf {
  echo "Converting AsciiDoc files from ${ADOC_SOURCE_DIR} to PDF..."

  ADOC_MAIN_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
  PDF_TARGET_FILE="${PDF_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.pdf"

  echo "Converting ${ADOC_MAIN_FILE} to ${PDF_TARGET_FILE}..."

  asciidoctor-pdf \
      -a outlinelevels=4 \
      -a pdf-fontsdir="GEM_FONTS_DIR;${FONTS_BASE_DIR}" \
      -a pdf-themesdir="${THEMES_DIR}" \
      -a pdf-theme=pdf \
      "${ADOC_MAIN_FILE}" \
      -o "${PDF_TARGET_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
PDF_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/pdf"
mkdir -p "${PDF_TARGET_DIR}"

# Create a symbolic link to the assets directory, so that we can include all assets in future generated files
ASSETS_DIR="$(pwd)/assets"
ln -s "${ASSETS_DIR}" "${ADOC_SOURCE_DIR}" || echo "assets link already exists"
FONTS_BASE_DIR="${ADOC_SOURCE_DIR}/assets/fonts"

THEMES_DIR="$(pwd)/${INPUT_BOOK_DIRECTORY}/themes"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to a PDF file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
find_and_download_images
convert_asciidoc_to_pdf
popd
