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

  fileCounter=0;
  for adoc in $(find . -name '*.adoc'); do
  fileCounter=$((fileCounter+1))
    #echo "${fileCounter}. Processing images in ${adoc}..."
    while read -r inlineImageMacro ; do
      echo "Processing inline image ${inlineImageMacro}..."
      if [[ "${inlineImageMacro}" =~ ^image:(https?://[a-zA-Z0-9\._\/-]+)\[(.*)\]$ ]]; then
        IMAGE_URL="${BASH_REMATCH[1]}"
        ALT_TEXT="${BASH_REMATCH[2]}"
        printf "${GREEN}Found URL ${IMAGE_URL} and alt text \"${ALT_TEXT}\" in inline image.${ENDCOLOR}\n"
        FILE_NAME="${IMAGE_URL##*/}"
        if [ -f "${DOWNLOADED_IMAGES_DIR}/${FILE_NAME}" ]; then
          echo "Image ${FILE_NAME} already exists, skipping download."
        else
          curl --create-dirs -O --output-dir "${DOWNLOADED_IMAGES_DIR}" "${IMAGE_URL}"
        fi

        echo "Replacing ${IMAGE_URL} with ${DOWNLOADED_IMAGES_DIR}/${FILE_NAME} for inline images."
        sed -i'.imagepath.bak' -e "s|${IMAGE_URL}|${DOWNLOADED_IMAGES_DIR}/${FILE_NAME}|g" "$adoc"
      else
        printf "${RED}No URL found for inline image ${inlineImageMacro}${ENDCOLOR}\n"
      fi
    done < <(grep '^image:http' "$adoc")
    while read -r blockImageMacro ; do
      echo "Processing block image ${blockImageMacro}..."
      if [[ "${blockImageMacro}" =~ ^image::(https?://[a-zA-Z0-9\._\/-]+)\[(.*)\]$ ]]; then
        IMAGE_URL="${BASH_REMATCH[1]}"
        ALT_TEXT="${BASH_REMATCH[2]}"
        printf "${GREEN}Found URL ${IMAGE_URL} and alt text \"${ALT_TEXT}\" in block image.${ENDCOLOR}\n"
        curl --create-dirs -O --output-dir "${DOWNLOADED_IMAGES_DIR}" "${IMAGE_URL}"

        FILE_NAME="${IMAGE_URL##*/}"
        echo "Replacing ${IMAGE_URL} with ${DOWNLOADED_IMAGES_DIR}/${FILE_NAME} for block images."
        sed -i'.imagepath.bak' -e "s|${IMAGE_URL}|${DOWNLOADED_IMAGES_DIR}/${FILE_NAME}|g" "$adoc"
      else
        printf "${RED}No URL found for block image ${blockImageMacro}${ENDCOLOR}\n"
      fi
    done < <(grep '^image::http' "$adoc")
    if (( fileCounter % 50 == 0 )); then
      # This seems to prevent errors that sometimes occur with grep after a certain number of scanned files.
      sleep 0.01;
    fi
  done
}
