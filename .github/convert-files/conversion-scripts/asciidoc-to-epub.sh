#!/usr/bin/env bash

set -euo pipefail

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

function find_and_download_images {
  echo "Detecting and downloading web-based images referenced in ${ADOC_SOURCE_DIR}..."

  DOWNLOADED_IMAGES_DIR="assets/images/downloaded/${INPUT_BOOK_MAIN_FILE}"
  mkdir -p "${DOWNLOADED_IMAGES_DIR}"
  echo "Images will be downloaded to $(pwd)/${DOWNLOADED_IMAGES_DIR}"

  for adoc in $(find . -name '*.adoc'); do
    while read -r inlineImageMacro ; do
      echo "Processing inline image ${inlineImageMacro}..."
      if [[ "${inlineImageMacro}" =~ ^image:(https?://[a-zA-Z0-9\._\/-]+)\[(.*)\]$ ]]; then
        IMAGE_URL="${BASH_REMATCH[1]}"
        ALT_TEXT="${BASH_REMATCH[2]}"
        printf "${GREEN}Found URL ${IMAGE_URL} and alt text \"${ALT_TEXT}\" in inline image.${ENDCOLOR}\n"
        curl --create-dirs -O --output-dir "${DOWNLOADED_IMAGES_DIR}" "${IMAGE_URL}"

        FILE_NAME="${IMAGE_URL##*/}"
        echo "Replacing ${IMAGE_URL} with ${DOWNLOADED_IMAGES_DIR}/${FILE_NAME} for inline images."
        sed -i'.imagepath.bak' -e "s|${IMAGE_URL}|${DOWNLOADED_IMAGES_DIR}/${FILE_NAME}|g" $adoc
      else
        printf "${RED}No URL found for inline image ${inlineImageMacro}${ENDCOLOR}\n"
      fi
    done < <(grep '^image:http' $adoc)
    while read -r blockImageMacro ; do
      echo "Processing block image ${blockImageMacro}..."
      if [[ "${blockImageMacro}" =~ ^image::(https?://[a-zA-Z0-9\._\/-]+)\[(.*)\]$ ]]; then
        IMAGE_URL="${BASH_REMATCH[1]}"
        ALT_TEXT="${BASH_REMATCH[2]}"
        printf "${GREEN}Found URL ${IMAGE_URL} and alt text \"${ALT_TEXT}\" in block image.${ENDCOLOR}\n"
        curl --create-dirs -O --output-dir "${DOWNLOADED_IMAGES_DIR}" "${IMAGE_URL}"

        FILE_NAME="${IMAGE_URL##*/}"
        echo "Replacing ${IMAGE_URL} with ${DOWNLOADED_IMAGES_DIR}/${FILE_NAME} for block images."
        sed -i'.imagepath.bak' -e "s|${IMAGE_URL}|${DOWNLOADED_IMAGES_DIR}/${FILE_NAME}|g" $adoc
      else
        printf "${RED}No URL found for block image ${blockImageMacro}${ENDCOLOR}\n"
      fi
    done < <(grep '^image::http' $adoc)
  done
}

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
find_and_download_images
convert_asciidoc_to_epub
popd
