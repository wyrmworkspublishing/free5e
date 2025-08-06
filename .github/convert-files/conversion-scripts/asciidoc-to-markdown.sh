#!/usr/bin/env bash

set -euo pipefail

function convert_asciidoc_to_markdown() {
  echo "Converting AsciiDoc files from ${ADOC_SOURCE_DIR} to Markdown..."

  ADOC_MAIN_UNREDUCED_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
  ADOC_REDUCED_FILE="${ADOC_REDUCED_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}-reduced.adoc"

  echo "Reducing ${ADOC_MAIN_UNREDUCED_FILE} to ${ADOC_REDUCED_FILE}..."
  asciidoctor-reducer \
    -o "${ADOC_REDUCED_FILE}" \
    "${ADOC_MAIN_UNREDUCED_FILE}"

  MD_TARGET_FILE="${MD_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.md"
  echo "Converting ${ADOC_REDUCED_FILE} to ${MD_TARGET_FILE}..."
  downdoc \
    -o "${MD_TARGET_FILE}" \
    "${ADOC_REDUCED_FILE}"
}

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"

ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
ADOC_REDUCED_TARGET_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc-reduced"
mkdir -p "${ADOC_REDUCED_TARGET_DIR}"
MD_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/md"
mkdir -p "${MD_TARGET_DIR}"

echo "Converting all AsciiDoc files in ${ADOC_SOURCE_DIR} to a single Markdown file. The settings are: language=${INPUT_LANGUAGE}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

pushd "${ADOC_SOURCE_DIR}"
convert_asciidoc_to_markdown
popd
