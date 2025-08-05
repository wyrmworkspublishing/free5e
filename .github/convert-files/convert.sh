#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Conversion ${INPUT_CONVERSION} requested for book ${INPUT_BOOK_MAIN_FILE} in language ${INPUT_LANGUAGE}"

case "${INPUT_CONVERSION}" in

  markdown-to-asciidoc)
    ${SCRIPT_DIR}/conversion-scripts/markdown-to-asciidoc.sh
    ;;

  asciidoc-to-docbook)
    ${SCRIPT_DIR}/conversion-scripts/asciidoc-to-docbook.sh
    ;;

  asciidoc-to-epub)
    ${SCRIPT_DIR}/conversion-scripts/asciidoc-to-epub.sh
    ;;

  asciidoc-to-html)
    ${SCRIPT_DIR}/conversion-scripts/asciidoc-to-html.sh
    ;;

  asciidoc-to-markdown)
    ${SCRIPT_DIR}/conversion-scripts/asciidoc-to-markdown.sh
    ;;

  asciidoc-to-pdf)
    ${SCRIPT_DIR}/conversion-scripts/asciidoc-to-pdf.sh
    ;;

  docbook-to-docx)
    ${SCRIPT_DIR}/conversion-scripts/docbook-to-docx.sh
    ;;

  docbook-to-latex)
    ${SCRIPT_DIR}/conversion-scripts/docbook-to-latex.sh
    ;;

  docbook-to-odt)
    ${SCRIPT_DIR}/conversion-scripts/docbook-to-odt.sh
    ;;

  *)
    echo "Unknown conversion ${INPUT_CONVERSION} not supported."
    echo "The following environment variables are known:"
    env | sort
    exit 1
    ;;
esac
