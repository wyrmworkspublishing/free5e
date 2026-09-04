#!/usr/bin/env bash

set -euo pipefail

source "$(dirname $0)/download-images.sh"

function convert_asciidoc_to_epub {
  echo "Converting AsciiDoc files from ${ADOC_SOURCE_DIR} to EPUB..."

  ADOC_MAIN_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
  EPUB_TARGET_FILE="${EPUB_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.epub"

  for adoc in $(find . -name '*.adoc'); do
    # remove :imagesdir: settings, since those are incorrect for the EPUB output
    sed -i'.imagesdir.bak' -e '/^:imagesdir:/d' $adoc
    # Use the png files rather than svgs
    sed -i'.svg.bak' -e 's/\.svg/\.png/g' $adoc
    # Updating the image paths and change them all to block images
    sed -i'.inline-images.bak' -e 's/image:[\.\/]*assets\/images\//image::/g' $adoc
    sed -i'.block-images.bak' -e 's/image::[\.\/]*assets\/images\//image::/g' $adoc
  done
  for adoc in $(find "${ADOC_SOURCE_DIR}/assets/images" -name '*.adoc'); do
    # Remove pdfwidth, scalewidth, float, align, and role in assets/images/*/*/*.adoc
    sed -i'.remove-image-metainfo.bak' -e 's/",.*\]$/"]/g' $adoc
  done

  echo "Converting ${ADOC_MAIN_FILE} to ${EPUB_TARGET_FILE}..."

  asciidoctor-epub3 \
      -a ebook-validate \
      -a outlinelevels=4 \
      -a series-name="Free5e" \
      -a imagesdir="assets/images" \
      "${ADOC_MAIN_FILE}" \
      -o "${EPUB_TARGET_FILE}"

  # Deleting backup files created by sed
  for bak in $(find . -name '*.bak'); do
    rm $bak
  done

  echo "Checking the validity of ${EPUB_TARGET_FILE}..."
  java -jar ${EPUBCHECK_PATH:-/free5e/epubcheck}/epubcheck.jar --version
  java -jar ${EPUBCHECK_PATH:-/free5e/epubcheck}/epubcheck.jar "${EPUB_TARGET_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

ADOC_ORIGINAL_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc-png"
cp -r "${ADOC_ORIGINAL_DIR}/" "${ADOC_SOURCE_DIR}"
ASSETS_DIR="$(pwd)/assets"
cp -r "${ASSETS_DIR}/fonts" "${ADOC_SOURCE_DIR}/assets/fonts"
cp -RL "${ASSETS_DIR}/images" "${ADOC_SOURCE_DIR}/assets/"
FONTS_BASE_DIR="${ADOC_SOURCE_DIR}/assets/fonts"

EPUB_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/epub"
mkdir -p "${EPUB_TARGET_DIR}"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to an EPUB file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
find_and_download_images
convert_asciidoc_to_epub
popd
