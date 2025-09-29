#!/usr/bin/env bash

set -euo pipefail

function convert_docbook_to_docx {
  echo "Converting DocBook file from ${DOCBOOK_SOURCE_DIR} to DOCX..."

  DOCBOOK_MAIN_FILE="${DOCBOOK_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.xml"
  DOCX_TARGET_FILE="${DOCX_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.docx"

  echo "Converting ${DOCBOOK_MAIN_FILE} to ${DOCX_TARGET_FILE}..."

  pandoc \
      -s \
      --toc \
      --toc-depth=2 \
      --from docbook \
      --to docx \
      --output "${DOCX_TARGET_FILE}" \
      "${DOCBOOK_MAIN_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

DOCBOOK_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/docbook"
DOCX_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/docx"
mkdir -p "${DOCX_TARGET_DIR}"

# Create a symbolic link to the assets directory, so that we can include all assets in future generated files
ASSETS_DIR="$(pwd)/assets"
ln -s "${ASSETS_DIR}" "${DOCBOOK_SOURCE_DIR}" || echo "assets link already exists"

echo "Converting the DocBook file in ${DOCBOOK_SOURCE_DIR} to a DOCX file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${DOCBOOK_SOURCE_DIR}"
convert_docbook_to_docx
popd
