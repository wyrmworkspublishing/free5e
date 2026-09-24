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
  done

  echo "Converting ${ADOC_MAIN_FILE} to ${EPUB_TARGET_FILE}..."

  if [ -n "${FRONT_IMAGE_FILE}" ]; then
    asciidoctor-epub3 \
        -a ebook-validate \
        -a outlinelevels=4 \
        -a series-name="Free5e" \
        -a front-cover-image="image:${FRONT_IMAGE_FILE}[Front Cover,1127,1595]" \
        "${ADOC_MAIN_FILE}" \
        -o "${EPUB_TARGET_FILE}"
  else
    asciidoctor-epub3 \
            -a ebook-validate \
            -a outlinelevels=4 \
            -a series-name="Free5e" \
            "${ADOC_MAIN_FILE}" \
            -o "${EPUB_TARGET_FILE}"
  fi

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
FRONT_IMAGE_FILE="${INPUT_FRONT_IMAGE_FILE}"

ADOC_ORIGINAL_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc-png"
cp -r "${ADOC_ORIGINAL_DIR}/" "${ADOC_SOURCE_DIR}"
ASSETS_DIR="$(pwd)/assets"
FONTS_BASE_DIR="${ADOC_SOURCE_DIR}/assets/fonts"
mkdir -p "${FONTS_BASE_DIR}"
cp -r "${ASSETS_DIR}/fonts" "${ADOC_SOURCE_DIR}/assets/" || echo "No fonts directory found, skipping copy."
cp -RL "${ASSETS_DIR}/images" "${ADOC_SOURCE_DIR}/assets/" || echo "No images directory found, skipping copy."
echo "The assets directory ${ADOC_SOURCE_DIR}/assets now contains the following objects:"
tree "${ADOC_SOURCE_DIR}/assets"

EPUB_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/epub"
mkdir -p "${EPUB_TARGET_DIR}"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to an EPUB file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
find_and_download_images
convert_asciidoc_to_epub
popd
