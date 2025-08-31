#!/usr/bin/env bash

set -euo pipefail

function convert_asciidoc_to_docbook {
  echo "Converting AsciiDoc files from ${ADOC_SOURCE_DIR} to DocBook..."

  ADOC_MAIN_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
  DOCBOOK_TARGET_FILE="${DOCBOOK_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.xml"

  echo "Converting ${ADOC_MAIN_FILE} to ${DOCBOOK_TARGET_FILE}..."

  lang="$(cut -d '-' -f1 <<< "$INPUT_LANGUAGE")"

  asciidoctor \
      -b docbook \
      -a lang=${lang} \
      "${ADOC_MAIN_FILE}" \
      -o "${DOCBOOK_TARGET_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
DOCBOOK_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/docbook"
mkdir -p "${DOCBOOK_TARGET_DIR}"

# Create a symbolic link to the assets directory, so that we can include all assets in future generated files
ASSETS_DIR="$(pwd)/assets"
ln -s "${ASSETS_DIR}" "${ADOC_SOURCE_DIR}" || echo "assets link already exists"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to a DocBook file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
convert_asciidoc_to_docbook
popd
