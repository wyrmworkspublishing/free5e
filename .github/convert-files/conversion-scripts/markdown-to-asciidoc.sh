#!/usr/bin/env bash

set -euo pipefail

git config --global --add safe.directory $PWD

CONVERSION_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Define a function for converting Markdown to AsciiDoc
function convert_markdown_to_asciidoc {
  echo "Converting Markdown files from $(pwd) to AsciiDoc..."

  lang="$(cut -d '-' -f1 <<< "$INPUT_LANGUAGE")"

  for md in $(find . -name '*.md'); do
    md_filepath="$(dirname -- $md)"
    md_filename="${md##*/}"
    adoc_filepath="${ADOC_TARGET_DIR}/${md_filepath}"
    adoc_filename="${md_filename%.md}.adoc"
    mkdir -p "${adoc_filepath}"

    # Convert all the Markdown files to AsciiDoc
    echo "Converting ${md} to ${adoc_filepath}/${adoc_filename}..."
    kramdoc \
      -a author="Wyrmworks Publishing"  \
      -a copyright="Creative Commons Attribution 4.0 International License (CC-BY-4.0)" \
      -a doctype=book \
      -a icons=font \
      -a lang="${lang}" \
      -a partnums \
      -a reproducible \
      -a revdate="$(LANG="${INPUT_LANGUAGE}" git log -1 --pretty="format:%cd" --date=format:"${INPUT_DATE_FORMAT}" .)" \
      -a sectnums \
      -a sectnumlevels=1 \
      -a stem \
      -a table-stripes=even \
      -a toc \
      -a toclevels=2 \
      --auto-ids \
      --auto-id-prefix="${md_filename%.md}_" \
      --auto-id-separator="_" \
      -o "${adoc_filepath}/${adoc_filename}" \
      $md
  done

  # Handle language specific attributes if defined
  attributesFile="../attributes.adoc"
  if [[ -f "${attributesFile}" ]]; then
    attributesTarget="${ADOC_TARGET_DIR}/attributes.adoc"
    echo "Language specific attributes file found, copying it to ${attributesTarget}..."
    cp "${attributesFile}" "${attributesTarget}"

    ADOC_MAIN_FILE="${ADOC_TARGET_DIR}/${INPUT_BOOK_MAIN_FILE}.adoc"
    sed -i'.attributes.bak' '/^:toc:$/i \
include::attributes.adoc[]\
' "${ADOC_MAIN_FILE}"
  else
    echo "No language specific attributes file found at ${attributesFile}."
  fi

  pushd "${ADOC_TARGET_DIR}"
  echo "Moved to $(pwd) for further processing..."

  # In the newly generated AsciiDoc files, replace links with includes
  echo "Replacing local links with includes..."
  for adoc in $(find . -name '*.adoc'); do
    sed -i'.include.bak' -e 's/^xref:\(.*\).adoc\[.*\]/include::\1.adoc[]/g' $adoc
  done

  # Mark the first chapter as the preface
  echo "Marking the first chapter as the preface..."
  for dir in $(find . -maxdepth 2 -type d -name '01_*'); do
    INTRODUCTION="$dir/$(ls $dir | head -n 1)"
    sed -i'.preface.bak' '1s/^/[preface]\n/' "$INTRODUCTION"
  done

  # Mark the appendices as such
  echo "Marking appendices as such..."
  for appendix_parent in $(find . -maxdepth 2 -type d -name 'A_*'); do
    for appendix_dir in $(ls -d $appendix_parent/*); do
      if [ -d "$appendix_dir" ]; then
        APPENDIX_FILE="$(ls $appendix_dir/*.adoc | head -n 1)"
        sed -i'.appendix.bak' '1s/^/[appendix]\n/' "$APPENDIX_FILE"
      fi
    done
  done

  # Now make sure that the tables look decent
  echo "Make sure that tables are rendered nicely..."
  for adoc in $(find . -name '*.adoc'); do
    if grep -q '|===' "$adoc"; then
      sed -i'.tables.bak' -e 's/^\[cols/\[%autowidth,width=100%\]\n\[cols/g' $adoc
      mv $adoc "$adoc.tables.bak"
      awk '
        /^$/ { blank++ }
        blank && /^\|===$/ { blank=0; print "[%autowidth,width=100%]" }
        /^./ { blank=0 }
        { print }
      ' "$adoc.tables.bak" > $adoc
    fi
  done

  # Render sidebars correctly
  echo "Make sidebars render correctly..."
  for adoc in $(find . -name '*.adoc'); do
    if grep -q '// style:sidebar' "$adoc"; then
      cp $adoc "$adoc.sidebars.bak"
      python3 $CONVERSION_SCRIPT_DIR/format-sidebars.py "$adoc.sidebars.bak" > $adoc
    fi
  done

  # Fix assets links
  for adoc in $(find . -name '*.adoc'); do
    if grep -q 'image:' "$adoc"; then
      sed -i'.images.bak' -e 's/image:[\.\/]*assets/image:assets/g' $adoc
      sed -i'.images.bak' -e 's/image::[\.\/]*assets/image::assets/g' $adoc
    fi
  done

  # If everything worked, remove the temporary backup files
  for bak in $(find . -name '*.bak'); do
    rm $bak
  done

  popd
}

echo "Converting all Markdown files in $(pwd) to AsciiDoc. The settings are: language=${INPUT_LANGUAGE}, book_directory=${INPUT_BOOK_DIRECTORY}, book_main_markdown_file=${INPUT_BOOK_MAIN_FILE}"

GENERATED_FILES_TARGET_DIRECTORY="${INPUT_GENERATED_FILES_TARGET_DIRECTORY:-generated}"
ADOC_TARGET_DIR="$(pwd)/${GENERATED_FILES_TARGET_DIRECTORY}/${INPUT_BOOK_MAIN_FILE}/adoc"
mkdir -p "${ADOC_TARGET_DIR}"
echo "About to generate files to ${ADOC_TARGET_DIR}..."

pushd "${INPUT_BOOK_DIRECTORY}"
convert_markdown_to_asciidoc
popd
