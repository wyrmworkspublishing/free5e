#!/usr/bin/env bash

set -euo pipefail

ARTIFACTS_TARGET_DIRECTORY="${INPUT_ARTIFACTS_TARGET_DIR:-artifacts}"
ADOC_SOURCE_DIR="$(pwd)/${ARTIFACTS_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
ADOC_MAIN_FILE="${ADOC_SOURCE_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"

echo "Validating AsciiDoc file ${ADOC_MAIN_FILE}..."
asciidoctor \
  -v \
  --failure-level=WARNING \
  "${ADOC_MAIN_FILE}"
