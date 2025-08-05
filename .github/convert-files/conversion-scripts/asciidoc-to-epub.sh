#!/usr/bin/env bash

set -euo pipefail

function convert_asciidoc_to_epub {
  echo "Converting AsciiDoc files from ${ADOC_SOURCE_DIR} to EPUB..."

  ADOC_MAIN_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
  EPUB_TARGET_FILE="${EPUB_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.epub"

  # Use the png files rather than svgs
  for adoc in $(find . -name '*.adoc'); do
    sed -i'.svg.bak' -e 's/\.svg/\.png/g' $adoc
  done

  echo "Converting ${ADOC_MAIN_FILE} to ${EPUB_TARGET_FILE}..."

  asciidoctor-epub3 \
      -a ebook-validate \
      -a outlinelevels=4 \
      -a series-name="Free5e" \
      "${ADOC_MAIN_FILE}" \
      -o "${EPUB_TARGET_FILE}"

  echo "Checking the validity of ${EPUB_TARGET_FILE}..."
  java -jar ${EPUBCHECK_PATH:-/free5e/epubcheck}/epubcheck.jar --version
  java -jar ${EPUBCHECK_PATH:-/free5e/epubcheck}/epubcheck.jar "${EPUB_TARGET_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

ADOC_ORIGINAL_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc-png"
cp -r "${ADOC_ORIGINAL_DIR}" "${ADOC_SOURCE_DIR}"

EPUB_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/epub"
mkdir -p "${EPUB_TARGET_DIR}"

# Create a symbolic link to the assets directory, so that we can include all assets in future generated files
ASSETS_DIR="$(pwd)/assets"
ln -s "${ASSETS_DIR}" "${ADOC_SOURCE_DIR}" || echo "assets link already exists"
FONTS_BASE_DIR="${ADOC_SOURCE_DIR}/assets/fonts"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to an EPUB file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
convert_asciidoc_to_epub
popd
