# Free5e Repository
<!-- spell-checker:words BASEFILE blalasaadri Guía Jugador languagecode Libro Monstruos -->
<!-- markdownlint-disable blanks-around-fences -->

This repository contains:

- A Discord glossary bot in the `bot/` folder (used with Render)
- Free5e public resources in the `public-resources/` folder

## What is Free5e?

Free5e is a fully open, community-built alternative to 5e tabletop roleplaying rules. It’s designed to be:

- **Fully free** to use, share, modify, and publish under Creative Commons BY 4.0.
- **Accessible and inclusive**, with disability representation, mixed ancestries and cultures, and alternative formats.
- **System-compatible** with other 5e variants, with conversion tools for 2014/2024 5e, Tales of the Valiant, and Level Up: Advanced 5e.
- **Modular and expandable**, with player-facing and GM tools that allow for broad customizations without breaking balance.

Use this repo to contribute, build tools, translate, or develop your own projects using Free5e.

## File formats

The books in this repository are written in the Markdown format, specifically in [GitHub Flavored Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).
These files are then automatically converted into a number of formats.
Specifically:

- [AsciiDoc](https://asciidoc.org/) (mostly as an intermediate file type)
- HTML
- PDF (version 1.4)
- [EPUB](https://en.wikipedia.org/wiki/EPUB) (version 3)
- [DocBook](https://docbook.org/) (as an intermediate file type)
- [DOCX](https://en.wikipedia.org/wiki/Office_Open_XML) (the standard format by Microsoft Word)
- [OpenDocument / ODT](https://en.wikipedia.org/wiki/OpenDocument) (the standard format used by [LibreOffice](https://www.libreoffice.org/))
- [LaTeX](https://www.latex-project.org/)

These files are generated when a new version is merged into the `main` branch of this repository, and can then be released if so desired.

## Spell checking
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

### Spell checking before pushing to GitHub
`cspell`, the spell checker used here, can be run locally as well.
For example, the [cspell GitHub repository](https://github.com/streetsidesoftware/cspell/tree/main/packages/cspell) links to [a plugin](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker) for Visual Studio Code and also explains how to run it via the command line.
(Though admittedly, the description is very technical.)

<!--
This is in a code comment, since it's not relevant to most people.
But it's helpful to look up in some very specific cases.
```sh
cd en-US
# Creating a new, empty cspell config file
docker run -v $PWD:/workdir ghcr.io/streetsidesoftware/cspell:latest "init"
# Running the spell checker manually via Docker
docker run -v $PWD:/workdir ghcr.io/streetsidesoftware/cspell:latest "**/*.md"
```
-->

## Adding translations
To add a translation, create a new directory using the [2 letter ISO 639 language code](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes) in lower case (e.g. `en` for English or `fr` for French), followed by a dash, followed by the [2 letter ISO 3166-1 country code](https://en.wikipedia.org/wiki/ISO_3166-1#Codes) for the region in upper case (e.g. `US` for the United States of America, or `GB` for the United Kingdom).
This results in directories representing regional languages, so that we can differentiate between not only very broad languages (e.g. English or French), but also regional languages (e.g. American English vs. British English, or French French vs. Canadian French).

In this directory, create subdirectories for each book you're translating (e.g. _"Players_Guide"_) and in that at least one Markdown file, which will serve as the starting point for that book.

For each book you added, modify the `.env` file in the base repository in the following manner:

1. Add the new language to the `LANGUAGES_TO_RENDER` variable, separating language codes by commas. So for example, if you initially have the entry
   ```env
   LANGUAGES_TO_RENDER=en-US;fr-CA
   ```
   and you want to add Mexican Spanish, you'd change that line to
   ```env
   LANGUAGES_TO_RENDER=en-US;fr-CA;es-MX
   ```
2. Add variables for the paths to each book that has been added.
   Specifically:
   - For the Player's book, add a variable starting with `BASEFILE_PLAYER_BOOK_` and followed by the regional language as above, however separated by an underscore (`_`) rather than by a dash.
   - For the Conductor's book, add a variable starting with `BASEFILE_CONDUCTOR_BOOK_` and followed by the regional language as above, however separated by an underscore (`_`) rather than by a dash.
   - For the Monster book, add a variable starting with `BASEFILE_MONSTER_BOOK_` and followed by the regional language as above, however separated by an underscore (`_`) rather than by a dash.

   For example, the new entries for Mexican Spanish may look like this:
   ```env
   # Mexican Spanish book paths
   BASEFILE_PLAYER_BOOK_es_MX=es-MX/Guía_del_Jugador/Guía_del_Jugador.md
   BASEFILE_CONDUCTOR_BOOK_es_MX=es-MX/Manual_del_Director/Manual_del_Director.md
   BASEFILE_MONSTER_BOOK_es_MX=es-MX/Libro_de_Monstruos/Libro_de_Monstruos.md
   ```

If this is done correctly, the render job will pick up the new translations and will build all of the expected formats from those files.

### Adding spell checks for translations

To add a spell check for a new translation, first copy the [en-US/cspell.config.yaml](./en-US/cspell.config.yaml) file to the new language directory.
In this new file, change the language to whatever language you're translating to.
For example the file may look like this:
```yml
# yaml-language-server: $schema=https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json

# The version of the configuration file format.
version: "0.2"
# The locale to use when spell checking. (e.g., en, en-GB, de-DE
language: es-MX
dictionaryDefinitions:
  - name: free5e
    path: ./dictionary.txt
    addWords: true
dictionaries:
  - free5e
```
Next, create a `dictionary.txt` file next to the new `cspell.config.yml` file.
This file will contain all words that cspell doesn't know already.

Next, the file [.github/workflow/spellcheck.yml](./.github/workflows/spellcheck.yml) has to be modified.
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
          root: 'en-US'
          suggestions: true
  // This is new
  spellcheck-es-mx:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: streetsidesoftware/cspell-action@v7
        with:
          files: '**/*.md'
          root: 'es-MX'
          suggestions: true
```
Once this is done, commit the changes to GitHub and check the output of the new action.

<!-- markdownlint-disable descriptive-link-text -->
**Note:**
It is possible, that no default dictionary is installed for a requested language.
`cspell` has dictionaries available for many languages (they are listed [here](https://github.com/streetsidesoftware/cspell-dicts?tab=readme-ov-file#natural-language-dictionaries)), but not all of them come preinstalled with the GitHub action we use.
If a dictionary seems to be missing, tag @blalasaadri in a GitHub issue or request support from him on the Free5e Discord.
<!-- markdownlint-enable descriptive-link-text -->
<!--
Not exactly the Docker image we're using, but maybe useful nevertheless:
https://github.com/streetsidesoftware/cspell-cli/blob/main/docker/german/README.md

The available dictionaries are listed here:
https://github.com/streetsidesoftware/cspell-dicts
-->

## Licenses

Free5e is published under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed) license.
A copy of that license can be found in the file [LICENSE.md](./LICENSE.md).

Some of the provided file formats use the [Roboto](https://github.com/googlefonts/roboto-3-classic) font, copyright 2011 The Roboto Project Authors (https://github.com/googlefonts/roboto-classic).
Roboto is licensed under the [SIL Open Font License, Version 1.1](https://openfontlicense.org/open-font-license-official-text/).
A copy of this license can be found in the file [assets/fonts/roboto/OFL.md](./assets/fonts/roboto/OFL.md), and it is also available with a FAQ at [openfontlicense.org](https://openfontlicense.org).
