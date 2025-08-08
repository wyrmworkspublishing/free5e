# Free5e translation guide
<!-- spell-checker:words wyrmworkspublishing dndbeyond languagecode -->

Part of Free5e being released under the CC-BY 4.0 license is, that anyone can translate it into any language.
This document is intended to make doing so easier.

There are two basic paths, how you could create a new translation:

1. You can create a [fork](https://docs.github.com/de/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) of this repository and then work on that independently from the main repository at [github.com/wyrmworkspublishing/free5e](https://github.com/wyrmworkspublishing/free5e).
2. You can request to be a contributor to this repository, and as such work directly on the code here. To do so, please contact @wyrmworkspublishing.

## Resources for translating Free5e

### The System Reference Document 5.1

Free5e draws heavily on the so called _System Reference Document v5.1_, also known as the _SRD 5.1_.
The English version of the SRD is available under the [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/deed.en) ("CC-BY-4.0") license on [dndbeyond.com](https://www.dndbeyond.com/srd?srsltid=AfmBOorfZoIfRrNYFLuSgfHXP0myxaO4nOBJ82fwJNgXqkRqnLAhOi8b#SystemReferenceDocumentv51) (no account required).

There are also official translations of the SRD 5.1 available in the following languages and under the same license:

- [French](https://media.wizards.com/2023/downloads/dnd/SRD_CC_v5.1_FR.pdf)
- [German](https://media.wizards.com/2023/downloads/dnd/SRD_CC_v5.1_DE.pdf)
- [Italian](https://media.wizards.com/2023/downloads/dnd/SRD_CC_v5.1_IT.pdf)
- [Spanish](https://media.wizards.com/2023/downloads/dnd/SRD_CC_v5.1_ES.pdf)

These can be used as references while translating Free5e.

If used, the translated SRD has be referenced in the _Legal_ section of the translation.
The [Legal.md in the US English Character's Codex](./en-US/Characters_Codex/Legal.md) is a good example of how to do this in the English version.

## Setting up a new translation directory

In this repository, each translation lives in its on directory, named after the language it's written in.
The directory names are determined by using the [2 letter ISO 639 language code](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes) in lower case (e.g. `en` for English or `fr` for French), followed by a dash, followed by the [2 letter ISO 3166-1 country code](https://en.wikipedia.org/wiki/ISO_3166-1#Codes) for the region in upper case (e.g. `US` for the United States of America, or `GB` for the United Kingdom).
So for example, the US English version can be found in the directory [en-US](./en-US) while the German version would be in `de-DE` and the Mexican Spanish version in `es-MX` respectively.

This results in directories representing regional languages, so that we can differentiate between not only very broad languages (e.g. English or French), but also regional languages (e.g. American English vs. British English, or French French vs. Canadian French).

In this directory, create a new subdirectory for each book you're translating.
This will normally be named after the book or document you're translating; e.g. in the `en-US` directory you can find:

- [en-US/Characters_Codex](./en-US/Characters_Codex/) for the _Character's Codex_
- [en-US/Conductors_Companion](./en-US/Conductors_Companion/) for the _Conductor's Companion_
- [en-US/Migration_Guide](./en-US/Migration_Guide/) for the _5e to Free5e Migration Guide_
- [en-US/Characters_Codex](./en-US/Monstrous_Manuscript/) for the _Monstrous Manual_

You can create one of those directories to start with and then add others later.

### Book file structure

The automatic workflow that generates various file formats from the books makes a few assumptions about how the file structure within those book directories work:

- There is **exactly one** main Markdown file; e.g. for the US English version of the _Character's Codex_ this would be [en-US/Characters_Codex/Characters_Codex.md](./en-US/Characters_Codex/Characters_Codex.md).
- The various parts and chapters of the book are in subdirectories.
  These subdirectories follow certain naming conventions:
  - The directories for regular book parts start with two digits and an underscore in the order that they appear (e.g. [01_Introduction](./en-US/Characters_Codex/01_Introduction/) for the introduction / preface and [03_Creating_a_Character](./en-US/Characters_Codex/03_Creating_a_Character/) for everything on how to create a character).
  - There is exactly one directory for all parts of the appendix, which starts with `A_`.
- Directly in the directory starting with `01_`, there should be exactly one Markdown file.
  (Subdirectories would be OK though.)
  This file will be marked as the [preface](https://en.wikipedia.org/wiki/Preface) of the book and formatted accordingly in various generated files.
- Directly in the directory starting with `A_`, there should also be exactly one Markdown file.
  However there are also various subdirectories for the various parts of the appendix, following the same logic as the book parts (so starting with two digits followed by an underscore).
  Each of these subdirectories again should contain exactly one Markdown file directly, and optionally a number of subdirectories with more Markdown files.
  These files will be marked as belonging to the [appendix](https://en.wikipedia.org/wiki/Addendum) during file generation, which will influence the chapter numbering.

  A simple example for this with just one Markdown is [en-US/Characters_Codex/A_Appendix/01_Conditions](./en-US/Characters_Codex/A_Appendix/01_Conditions/) (which has the chapter number `A.1` in generated files), while [en-US/Characters_Codex/A_Appendix/02_Cross-System_Character_Conversion](./en-US/Characters_Codex/A_Appendix/02_Cross-System_Character_Conversion/) is a more complex example (chapter number `A.2`).

## Setting up spell checking

Every time changes are pushed to the GitHub repository, a GitHub Action (using the [cspell-action](https://github.com/streetsidesoftware/cspell-action), as defined in the file [spellcheck.yml](./.github/workflows/spellcheck.yml)) will check the spelling within Markdown files.

Each language directory contains two files relevant to spell checking:

- `cspell.config.yaml`
- `dictionary.txt`

The `cspell.config.yaml` is used for configuration and shouldn't have to be changed very often.
It is documented [in the cspell GitHub repository](https://github.com/streetsidesoftware/cspell/tree/main/packages/cspell#customization).

The results of spell checking can be found in the [Actions tab](https://github.com/wyrmworkspublishing/free5e/actions).
If unknown words are found during the spell check, there will sometimes be suggestions for fixes, e.g.:
<!-- spell-checker:disable -->
```
Unknown word (Proficieny) Suggestions: (proficient, proficiency, proficients, proficiently, profiling)
```
<!-- spell-checker:enable -->
Completely unknown words will be reported without suggestions on how to fix them.

If the spelling of a word is correct but not known to the spell checker (e.g. because it is a fantasy word), we can add that word to the language specific dictionary `<language>/dictionary.txt`.
While not strictly necessary, for better readability the terms in this file should be listed alphabetically.

### Creating spell checking files for a new language

To set up spell checking for a specific language, copy the file [en-US/cspell.config.yaml](./en-US/cspell.config.yaml) into the new language directory and create an empty `dictionary.txt` file next to it.
In the new `cspell.config.yaml` file, change the selected language; so for example, for German from Germany the line starting with `language:` would be changed to

```yml
language: de-DE
```

while for Mexican Spanish it would be:

```yml
language: ex-MX
```

In general these codes follow the same logic as the [translation directories](#setting-up-a-new-translation-directory), though it is possible that not all languages are available for spell checking.

[This list](https://github.com/streetsidesoftware/cspell-dicts?tab=readme-ov-file#natural-language-dictionaries) shows the languages that the spell checker can check.
If a language _is_ available for the spell checker, find it in the [**All Dictionaries** list](https://github.com/streetsidesoftware/cspell-dicts?tab=readme-ov-file#all-dictionaries) below.
The line should contain a package such as `@cspell/dict-de-de`.

Copy that and edit the `cspell.config.yaml` again.
After the `version:` line, insert the following:

```yml
import:
  - '<the text you just copied>/cspell-ext.json'
```

and replace `<the text you just copied>` with the part you just copied.
So for example, for German the `cspell.config.yaml` would look like this:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json

# The version of the configuration file format.
version: "0.2"
import:
  - '@cspell/dict-de-de/cspell-ext.json'
# The locale to use when spell checking. (e.g., en, en-GB, de-DE)
language: de-DE
dictionaryDefinitions:
  - name: free5e
    path: ./dictionary.txt
    addWords: true
dictionaries:
  - free5e
```

If cspell _doesn't_ directly support the language you're translating to, you may be able to use a similar language.
For example, cspell doesn't have a specific package for Mexican Spanish, but it does have one for Spanish from Spain.
So the `cspell.config.js` may look like this:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json

# The version of the configuration file format.
version: "0.2"
import:
  - '@cspell/dict-es-es/cspell-ext.json'
# The locale to use when spell checking. (e.g., en, en-GB, de-DE)
language: de-ES
dictionaryDefinitions:
  - name: free5e
    path: ./dictionary.txt
    addWords: true
dictionaries:
  - free5e
```

### Running the spell checker in GitHub

To run the spell checker for each change made in the GitHub repository,  the file [.github/workflow/spellcheck.yml](./.github/workflows/spellcheck.yml) has to be modified.
This file defines the spell checking jobs that are run when new changes are pushed to Github.
Under `jobs`, add a new job named `spellcheck-<languagecode>`, where `<languagecode>` is replaced with the language code.
For example, if we were adding a new job for Mexican Spanish, it would look like this:

```yml
jobs:
  // This remains unchanged
  spellcheck-en-us:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: streetsidesoftware/cspell-action@v7
        with:
          files: '**/*.md'
          root: './en-US'
          suggestions: true
          strict: true
  // This is new
  spellcheck-es-mx:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: streetsidesoftware/cspell-action@v7
        with:
          files: '**/*.md'
          root: './es-MX'
          suggestions: true
          strict: true

```

Once this is done, commit the changes to GitHub and check the output of the new action.

### Spell checking before pushing to GitHub

`cspell`, the spell checker used here, can be run locally as well.
For example, the [cspell GitHub repository](https://github.com/streetsidesoftware/cspell/tree/main/packages/cspell) links to [a plugin](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) for Visual Studio Code and also explains how to run it via the command line.
(Though admittedly, the description is very technical.)

### Adding unknown words

Free5e is a fantasy game, and as such it contains a number of words that are probably not commonly used and that the spell checker may therefore not know
There are two main ways to add words to those accepted by the spell checker:

- If a word is likely to be used multiple times throughout the books, such as `archdevil` or `handaxe`, add it to the `dictionary.txt` file.
  Each word here should be in a new line.
  While not strictly necessary, for better readability the terms in this file should be listed alphabetically.
- If a word is likely to be used only in a single file (e.g. specific terms used only in one spell), you can add it to the dictionary for that Markdown file only.
  To do so, add an HTML comment to the file at some point before the word occurs, that has the following format:

  ```html
  <!-- spell-checker:words archdevil -->
  ```

  To add multiple words in this way, you can either have multiple comments or you can separate the words in one comment by spaces, e.g.:

  ```html
  <!-- spell-checker:words archdevil handaxe -->
  ```

## Setting up file conversion

This repository is set up to automatically generate multiple file formats for each book or document.
To add this setup for a new language, create a new text file called `convert-files-<language code>.yml` (with the same language code as the [translation directory](#setting-up-a-new-translation-directory)) in the directory [`.github/workflows/`](./.github/workflows/).
This file should contain the following, replacing `<language description>` with a human readable description of tha language (e.g. "US English" or "Mexican Spanish"):

```yaml
name: Convert the <language description> manuscripts into various formats
run-name: <language description> file conversion triggered on on branch ${{ github.ref }} by ${{ github.actor }}...
on:
  push:
    branches:
      - main
      - 'translation/**'
      - 'translations/**'
      - 'convert/**'

jobs:
```

followed by a job entry like the following for each book or document to be generated:

```yaml
  convert-characters-codes-<language code>:
    name: Convert the <language code> <document name>
    uses: ./.github/workflows/convert-files.yml
    with:
      language: <language code>
      date_format: '<date format>'
      book_directory: '<path to book directory>'
      book_main_file: '<name of main book file with no file suffix>'
```

Replace the following:

- `<language code>` with the language code (as above), e.g. `de-DE` or `es-MX`
- `<document name>` with a human readable description of the document to be converted, e.g. `Character's Codex` or `5e to Free5e Migration Guide`
- `<date format>` with a date format as described below; this is used for the "last changes" date in the generated documents
- `<path to book directory>` with the path to the book directory, e.g. `en-US/Characters_Codex` or `en-US/Migration_Guide`
- `<name of main book file with no file suffix>` with the file name of the main Markdown file, but **without** the file suffix `.md`; so e.g. if the file is at `en-US/Migration_Guide/5e_Migration_Guide.md` this value would be `5e_Migration_Guide`

<!-- spell-checker:words fuer Charaktere -->
For example, to generate the German version of the Character's Companion, this could look as follows:

```yaml
  convert-characters-codes-de-DE:
    name: Convert the de-DE Codex für Charaktere
    uses: ./.github/workflows/convert-files.yml
    with:
      language: de-DE
      date_format: '%d.%m.%Y'
      book_directory: 'de-DE/Codex_fuer_Charaktere'
      book_main_file: 'Codex_fuer_Charaktere'
```

There can be multiple such jobs (as can be seen in the file [`.github/workflows/convert-files-en-US.yml`](./.github/workflows/convert-files-en-US.yml)), one for each document to be converted.

### Determining the date format
<!-- spell-checker:words Enero -->

As documented in the [Git documentation for `--date=format:...`](https://git-scm.com/docs/git-log#Documentation/git-log.txt---dateformat), the places this value is used accept the arguments for [strftime](https://www.man7.org/linux/man-pages/man3/strftime.3.html) except for `%s`, `%z`, and `%Z`.

So for example, the format `'%d.%m.%Y'` will result in a date such as `28.03.2025` for March 28th, 2025, while the format `'%Y-%m-%d'` will result in `2025-03-28` for the same date.
Terms such as days of the week or months will be rendered in the language in question (e.g. _"January"_ for the language `en-US` and _"Enero"_ for `es-MX`).
