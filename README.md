# Free5e Repository
<!-- spell-checker:words BASEFILE blalasaadri Guía Hyperlegible Jugador languagecode Libro Monstruos openfontlicense -->
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

## How to contribute

Check the (incomplete) [contribution guide](./CONTRIBUTION_GUIDE.md) for information on how to contribute to Free5e.

### Adding translations

Check the the [translation guide](TRANSLATION_GUIDE.md) for information on adding translations of Free5e.

## Licenses

Free5e is published under the [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed) license.
A copy of that license can be found in the file [LICENSE.md](./LICENSE.md).

Some of the provided file formats use the [Atkinson Hyperlegible™](https://www.brailleinstitute.org/freefont/) font family, copyright 2020, Braille Institute of America, Inc. ([https://www.brailleinstitute.org/](https://www.brailleinstitute.org/)), with Reserved Font Names: “ATKINSON” and “HYPERLEGIBLE”.
Atkinson Hyperlegible™ is licensed under the [SIL Open Font License, Version 1.1](https://openfontlicense.org/open-font-license-official-text/).
A copy of this license can be found in the file [assets/fonts/atkinson_hyperlegible/OFL.md](./assets/fonts/atkinson_hyperlegible/OFL.md), and it is also available with a FAQ at [openfontlicense.org](https://openfontlicense.org).

Some of the provided file formats use the [Roboto](https://github.com/googlefonts/roboto-3-classic) font, copyright 2011 The Roboto Project Authors ([https://github.com/googlefonts/roboto-classic](https://github.com/googlefonts/roboto-classic)).
Roboto is licensed under the [SIL Open Font License, Version 1.1](https://openfontlicense.org/open-font-license-official-text/).
A copy of this license can be found in the file [assets/fonts/roboto/OFL.md](./assets/fonts/roboto/OFL.md), and it is also available with a FAQ at [openfontlicense.org](https://openfontlicense.org).
