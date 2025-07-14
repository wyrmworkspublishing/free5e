# Free5e Repository

This repository contains:

* A Discord glossary bot in the `bot/` folder (used with Render)
* Free5e public resources in the `public-resources/` folder

## What is Free5e?

Free5e is a fully open, community-built alternative to 5e tabletop roleplaying rules. It’s designed to be:

* **Fully free** to use, share, modify, and publish under Creative Commons BY 4.0.
* **Accessible and inclusive**, with disability representation, mixed ancestries and cultures, and alternative formats.
* **System-compatible** with other 5e variants, with conversion tools for 2014/2024 5e, Tales of the Valiant, and Level Up: Advanced 5e.
* **Modular and expandable**, with player-facing and GM tools that allow for broad customizations without breaking balance.

Use this repo to contribute, build tools, translate, or develop your own projects using Free5e.

## File formats

The books in this repository are written in the Markdown format, specifically in [GitHub Flavored Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).
These files are then automatically converted into a number of formats.
Specifically:
- [AsciiDoc](https://asciidoc.org/) (mostly as an itermediate file type)
- HTML
- PDF (version 1.4)
- [EPUB](https://en.wikipedia.org/wiki/EPUB) (version 3)
- [DocBook](https://docbook.org/) (as an intermediate file type)
- [DOCX](https://en.wikipedia.org/wiki/Office_Open_XML) (the standard format by Microsoft Word)
- [OpenDocument / ODT](https://en.wikipedia.org/wiki/OpenDocument) (the standard format used by [LibreOffice](https://www.libreoffice.org/))
- [LaTeX](https://www.latex-project.org/)

These files are generated when a new version is merged into the `main` branch of this repository, and can then be released if so desired.

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
   - For the Player's book, add a variable starting with `BASEFILE_PLAYER_BOOK_` and followed by the regional language as above, nowever separated by an underscore (`_`) rather than by a dash.
   - For the Conductor's book, add a variable starting with `BASEFILE_CONDUCTOR_BOOK_` and followed by the regional language as above, nowever separated by an underscore (`_`) rather than by a dash.
   - For the Monster book, add a variable starting with `BASEFILE_MONSTER_BOOK_` and followed by the regional language as above, nowever separated by an underscore (`_`) rather than by a dash.

   For example, the new entries for Mexican Spanish may look like this:
   ```env
   # Mexican Spanish book paths
   BASEFILE_PLAYER_BOOK_es_MX=es-MX/Guía_del_Jugador/Guía_del_Jugador.md
   BASEFILE_CONDUCTOR_BOOK_es_MX=es-MX/Manual_del_Director/Manual_del_Director.md
   BASEFILE_MONSTER_BOOK_es_MX=es-MX/Libro_de_Monstruos/Libro_de_Monstruos.md
   ```
If this is done correctly, the render job will pick up the new translations and will build all of the expected formats from those files.
