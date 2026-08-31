#!/usr/bin/env python3

from __future__ import annotations

import argparse
import datetime
import json
import re
import subprocess
import sys
import textwrap
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


SUPPORTED_EXTENSIONS = {".md", ".markdown"}
TABLE_PRIOR_LINE_THRESHOLD = 3


@dataclass(frozen=True)
class BrailleProfile:
    slug: str
    label: str
    query: str
    grade: str


def run_command(command: list[str], *, input_text: str | None = None) -> str:
    try:
        completed = subprocess.run(
            command,
            input=input_text.encode("utf-8") if input_text is not None else None,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=True,
        )
    except subprocess.CalledProcessError as error:
        stderr = error.stderr.decode("utf-8", errors="replace")
        stdout = error.stdout.decode("utf-8", errors="replace")
        raise RuntimeError(
            f"Command failed: {' '.join(command)}\n\nSTDOUT:\n{stdout}\n\nSTDERR:\n{stderr}"
        ) from error

    return completed.stdout.decode("utf-8", errors="replace")


def normalize_text(text: str) -> str:
    replacements = {
        "\u00a0": " ",
        "\u2018": "'",
        "\u2019": "'",
        "\u201c": '"',
        "\u201d": '"',
        "\u2013": "-",
        "\u2014": "--",
        "\u2026": "...",
    }

    for old, new in replacements.items():
        text = text.replace(old, new)

    text = "\n".join(line.rstrip() for line in text.splitlines())
    text = re.sub(r"\n{4,}", "\n\n\n", text)

    return text.strip() + "\n"


def strip_inline_markup(text: str) -> str:
    text = re.sub(r"`([^`]+)`", r"\1", text)
    text = re.sub(r"\*\*([^*]+)\*\*", r"\1", text)
    text = re.sub(r"\*([^*]+)\*", r"\1", text)
    text = re.sub(r"__([^_]+)__", r"\1", text)
    text = re.sub(r"_([^_]+)_", r"\1", text)
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"<[^>\n]+>", "", text)
    return text.strip()


def extract_first_h1(markdown: str, source: Path) -> str:
    for line in markdown.splitlines():
        match = re.match(r"^\s*#\s+(.+?)\s*$", line)
        if match:
            title = re.sub(r"\s+#*$", "", match.group(1)).strip()
            return strip_inline_markup(title)

    print(
        f"::warning file={source}::No Heading 1 found. Filename promoted to title. Please glare at the Markdown later.",
        file=sys.stderr,
    )
    return source.stem.replace("_", " ").replace("-", " ").strip()


def clean_markdown(markdown: str) -> str:
    text = markdown

    # Frontmatter already had its turn. The braille title comes from the first H1.
    text = re.sub(r"\A---\s*\n.*?\n---\s*\n", "", text, flags=re.DOTALL)

    # Yada Wiki shortcodes with display text.
    text = re.sub(
        r'\[yadawiki[^\]]*?\bshow="([^"]+)"[^\]]*?\]',
        r"\1",
        text,
        flags=re.IGNORECASE,
    )

    # Yada Wiki shortcodes without display text. Better a readable target than bracket soup.
    text = re.sub(
        r'\[yadawiki[^\]]*?\blink="([^"]+)"[^\]]*?\]',
        r"\1",
        text,
        flags=re.IGNORECASE,
    )

    # Free5e tag/link format:
    # [.spell.spell-Fireball_fireball]#Fireball#
    # The class pile goes away; the reader gets the word.
    text = re.sub(r"\[[^\]\n]*?\]#([^#\n]+)#", r"\1", text)

    # Markdown images. Keep alt text because the picture is not coming along for the ride.
    text = re.sub(r"!\[([^\]]*)\]\([^)]+\)", r"Image: \1", text)

    # Markdown inline links:
    # _[nullified (sight)](#nullified)_ becomes _nullified (sight)_.
    # Pandoc can clean up the emphasis after we remove the link machinery.
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)

    # Markdown reference links:
    # [Fireball][spell-fireball] becomes Fireball.
    text = re.sub(r"\[([^\]]+)\]\[[^\]]*\]", r"\1", text)

    # Reference-link definitions can leave quietly.
    text = re.sub(r"^\s*\[[^\]]+\]:\s+\S+.*$", "", text, flags=re.MULTILINE)

    # WordPress-style shortcodes. Do this after Markdown links so useful link text survives.
    text = re.sub(
        r"\[/?[A-Za-z][A-Za-z0-9_-]*(?:\s+[^\]]*)?\]",
        "",
        text,
    )

    # HTML tags can leave their words at the door.
    text = re.sub(
        r"</?(?:span|div|p|section|article|aside|header|footer|main|br|hr)[^>]*>",
        " ",
        text,
        flags=re.IGNORECASE,
    )
    text = re.sub(
        r"</?(?:strong|em|b|i|u|small|sup|sub|code|kbd|samp)[^>]*>",
        "",
        text,
        flags=re.IGNORECASE,
    )
    text = re.sub(r"<[^>\n]+>", "", text)

    # Pandoc attribute leftovers: {#thing .also-thing}. Tiny syntax crumbs, begone.
    text = re.sub(r"\s*\{[#.][^}\n]+\}", "", text)

    # Keep hyphen bullets. Strip only escaped hard-break markers.
    text = text.replace("\\\n", "\n")

    return normalize_text(text)


def language_parts(language_tag: str) -> tuple[str, str]:
    pieces = language_tag.replace("_", "-").split("-")
    language = pieces[0].lower()
    region = ""

    for piece in pieces[1:]:
        if len(piece) == 2 and piece.isalpha():
            region = piece.upper()
            break

    return language, region


def profile_label(language_tag: str, grade: str) -> str:
    language, _region = language_parts(language_tag)

    if language == "en":
        if grade == "1":
            return "Unified English Braille, uncontracted"
        if grade == "2":
            return "Unified English Braille, contracted"

    if grade == "0":
        return f"{language_tag} braille, grade 0"
    if grade == "1":
        return f"{language_tag} braille, grade 1"
    if grade == "2":
        return f"{language_tag} braille, grade 2"

    return f"{language_tag} braille"


def candidate_queries(language_tag: str) -> Iterable[tuple[str, str]]:
    language, _region = language_parts(language_tag)

    # Try common literary grades. If Liblouis says no, we believe it and move along.
    for grade in ("1", "2", "0"):
        yield grade, f"language:{language} region:{language_tag} grade:{grade} type:literary"
        yield grade, f"language:{language} region:{language_tag} grade:{grade}"
        yield grade, f"language:{language} grade:{grade} type:literary"
        yield grade, f"language:{language} grade:{grade}"


def query_works(query: str) -> bool:
    try:
        run_command(["lou_checktable", query])
        return True
    except RuntimeError:
        return False


def select_braille_profiles(language_tag: str) -> list[BrailleProfile]:
    selected: dict[str, BrailleProfile] = {}

    for grade, query in candidate_queries(language_tag):
        if grade in selected:
            continue

        if not query_works(query):
            continue

        selected[grade] = BrailleProfile(
            slug=f"grade-{grade}",
            label=profile_label(language_tag, grade),
            query=query,
            grade=grade,
        )

    profiles = [selected[key] for key in sorted(selected.keys())]

    if not profiles:
        print(
            f"::warning::No Liblouis literary braille profile found for {language_tag}. "
            f"Skipping before the build starts cosplaying as certainty.",
            file=sys.stderr,
        )

    return profiles


def pandoc_json(markdown: str) -> dict:
    raw = run_command(
        ["pandoc", "--from=gfm+yaml_metadata_block+pipe_tables", "--to=json"],
        input_text=markdown,
    )

    return json.loads(raw)


def stringify_inlines(inlines) -> str:
    parts: list[str] = []

    for inline in inlines or []:
        kind = inline.get("t")
        content = inline.get("c")

        if kind == "Str":
            parts.append(str(content))
        elif kind in {"Space", "SoftBreak", "LineBreak"}:
            parts.append(" ")
        elif kind in {"Emph", "Strong", "Strikeout", "Superscript", "Subscript", "SmallCaps"}:
            parts.append(stringify_inlines(content))
        elif kind == "Code":
            parts.append(str(content[1]))
        elif kind == "Link":
            parts.append(stringify_inlines(content[1]))
        elif kind == "Image":
            alt_text = stringify_inlines(content[1])
            parts.append(f"Image: {alt_text}" if alt_text else "Image")
        elif kind == "Math":
            parts.append(str(content[1]))
        elif kind == "Quoted":
            parts.append(stringify_inlines(content[1]))
        elif kind == "Span":
            parts.append(stringify_inlines(content[1]))

    return re.sub(r"\s+", " ", "".join(parts)).strip()


def block_to_text(block) -> str:
    kind = block.get("t")
    content = block.get("c")

    if kind in {"Para", "Plain"}:
        return stringify_inlines(content)

    if kind == "Header":
        level = content[0]
        text = stringify_inlines(content[2])
        return f"{'#' * level} {text}"

    if kind == "CodeBlock":
        return str(content[1])

    if kind == "BlockQuote":
        quoted = blocks_to_plain_lines(content)
        return "\n".join(f"> {line}" if line else ">" for line in quoted)

    if kind == "BulletList":
        lines: list[str] = []
        for item in content:
            item_text = " ".join(blocks_to_plain_lines(item)).strip()
            if item_text:
                lines.append(f"- {item_text}")
        return "\n".join(lines)

    if kind == "OrderedList":
        lines = []
        start = content[0][0]
        for index, item in enumerate(content[1], start=start):
            item_text = " ".join(blocks_to_plain_lines(item)).strip()
            if item_text:
                lines.append(f"{index}. {item_text}")
        return "\n".join(lines)

    if kind == "HorizontalRule":
        return "---"

    return ""


def blocks_to_plain_lines(blocks) -> list[str]:
    lines: list[str] = []

    for block in blocks or []:
        if block.get("t") == "Table":
            caption, rows = table_to_rows(block)
            lines.extend(format_table(caption, rows, 40))
            continue

        text = block_to_text(block)
        if text:
            lines.extend(text.splitlines())

    return lines


def caption_to_text(caption) -> str:
    if isinstance(caption, list) and len(caption) == 2:
        blocks = caption[1]
        return " ".join(blocks_to_plain_lines(blocks)).strip()

    return ""


def cell_to_text(cell) -> str:
    try:
        blocks = cell[4]
    except Exception:
        return ""

    return " ".join(blocks_to_plain_lines(blocks)).strip()


def row_to_cells(row) -> list[str]:
    try:
        cells = row[1]
    except Exception:
        return []

    return [cell_to_text(cell) for cell in cells]


def rows_from_head_or_foot(part) -> list[list[str]]:
    if not isinstance(part, list) or len(part) < 2:
        return []

    rows = part[1]
    return [row_to_cells(row) for row in rows]


def rows_from_body(body) -> list[list[str]]:
    if not isinstance(body, list) or len(body) < 4:
        return []

    head_rows = body[2] or []
    body_rows = body[3] or []
    return [row_to_cells(row) for row in [*head_rows, *body_rows]]


def normalize_table_rows(rows: list[list[str]]) -> list[list[str]]:
    rows = [[cell.strip() for cell in row] for row in rows if any(cell.strip() for cell in row)]

    if not rows:
        return []

    width = max(len(row) for row in rows)

    normalized = []
    for row in rows:
        normalized.append(row + [""] * (width - len(row)))

    return normalized


def table_to_rows(block) -> tuple[str, list[list[str]]]:
    content = block.get("c", [])

    if len(content) == 6:
        _attr, caption, _colspecs, thead, tbodies, tfoot = content

        rows: list[list[str]] = []
        rows.extend(rows_from_head_or_foot(thead))

        for body in tbodies:
            rows.extend(rows_from_body(body))

        rows.extend(rows_from_head_or_foot(tfoot))

        return caption_to_text(caption), normalize_table_rows(rows)

    # Older Pandoc table shape. The skeleton still has bones.
    if len(content) == 5:
        caption, _aligns, _widths, headers, rows = content
        all_rows = [headers] if headers else []
        all_rows.extend(rows or [])
        return stringify_inlines(caption), normalize_table_rows(all_rows)

    return "", []


def simple_table_lines(caption: str, rows: list[list[str]]) -> list[str]:
    widths = [0] * len(rows[0])

    for row in rows:
        for index, cell in enumerate(row):
            widths[index] = max(widths[index], len(cell))

    lines: list[str] = []

    if caption:
        lines.append(f"Table: {caption}")

    for row_index, row in enumerate(rows):
        lines.append("  ".join(cell.ljust(widths[index]) for index, cell in enumerate(row)).rstrip())

        if row_index == 0 and len(rows) > 1:
            lines.append("  ".join("-" * widths[index] for index in range(len(widths))).rstrip())

    return lines


def listed_table_lines(caption: str, rows: list[list[str]]) -> list[str]:
    lines: list[str] = []

    if caption:
        lines.append(f"Table: {caption}")
    else:
        lines.append("Table")

    if not rows:
        return lines

    headers = rows[0]
    body = rows[1:] if len(rows) > 1 else []

    if not body:
        body = rows
        headers = [f"Column {index + 1}" for index in range(len(rows[0]))]

    for row_number, row in enumerate(body, start=1):
        lines.append(f"Row {row_number}")

        for column_number, value in enumerate(row):
            heading = headers[column_number].strip() or f"Column {column_number + 1}"
            value = value.strip() or "—"
            lines.append(f"{heading}: {value}")

    return lines


def format_table(caption: str, rows: list[list[str]], cells_per_line: int) -> list[str]:
    if not rows:
        return ["Table omitted: no readable table rows found."]

    widths = [0] * len(rows[0])

    for row in rows:
        for index, cell in enumerate(row):
            widths[index] = max(widths[index], len(cell))

    estimated_width = sum(widths) + (2 * (len(widths) - 1))
    has_runaway_cell = any(width > max(12, cells_per_line // 2) for width in widths)

    if estimated_width <= cells_per_line and not has_runaway_cell:
        return simple_table_lines(caption, rows)

    # Wide tables get listed. Columns are great until they turn into furniture.
    return listed_table_lines(caption, rows)


def document_to_segments(doc: dict, cells_per_line: int) -> list[tuple[str, str]]:
    segments: list[tuple[str, str]] = []
    text_lines: list[str] = []

    def flush_text() -> None:
        nonlocal text_lines
        content = "\n".join(text_lines).strip()
        if content:
            segments.append(("text", content))
        text_lines = []

    for block in doc.get("blocks", []):
        if block.get("t") == "Table":
            flush_text()
            caption, rows = table_to_rows(block)
            table_lines = format_table(caption, rows, cells_per_line)
            segments.append(("table", "\n".join(table_lines)))
            continue

        text = block_to_text(block)
        if text:
            if text_lines:
                text_lines.append("")
            text_lines.extend(text.splitlines())

    flush_text()
    return segments


def lou_translate(text: str, profile: BrailleProfile, display_table: str) -> str:
    return run_command(
        [
            "lou_translate",
            "--forward",
            "--display-table",
            display_table,
            profile.query,
        ],
        input_text=text if text.endswith("\n") else text + "\n",
    )


def wrap_translated_text(text: str, width: int) -> list[str]:
    wrapped: list[str] = []

    for raw_line in text.splitlines():
        line = raw_line.rstrip()

        if not line:
            wrapped.append("")
            continue

        pieces = textwrap.wrap(
            line,
            width=width,
            break_long_words=True,
            break_on_hyphens=False,
            replace_whitespace=False,
            drop_whitespace=False,
        )

        wrapped.extend(pieces or [""])

    while wrapped and wrapped[-1] == "":
        wrapped.pop()

    return wrapped


def paginate_segments(
    segments: list[tuple[str, str]],
    *,
    profile: BrailleProfile,
    display_table: str,
    cells_per_line: int,
    lines_per_page: int,
) -> list[list[str]]:
    pages: list[list[str]] = [[]]

    def current_page() -> list[str]:
        return pages[-1]

    def new_page() -> None:
        if current_page():
            pages.append([])

    for kind, source_text in segments:
        translated = lou_translate(source_text, profile, display_table)
        lines = wrap_translated_text(translated, cells_per_line)

        if not lines:
            continue

        # Short tables deserve a clean entrance. Nobody likes a table wedged under paragraph leftovers.
        if (
            kind == "table"
            and len(lines) < lines_per_page
            and len(current_page()) > TABLE_PRIOR_LINE_THRESHOLD
        ):
            new_page()

        for line in lines:
            if len(current_page()) >= lines_per_page:
                new_page()

            current_page().append(line)

        if current_page() and len(current_page()) < lines_per_page:
            current_page().append("")

    while pages and all(line == "" for line in pages[-1]):
        pages.pop()

    if not pages:
        return [[]]

    for page in pages:
        while page and page[-1] == "":
            page.pop()

    return pages


def pages_to_text(pages: list[list[str]]) -> str:
    return "\f\n".join("\n".join(page) for page in pages).rstrip() + "\n"


def make_frontmatter_source(
    *,
    title: str,
    braille_label: str,
    body_pages: int,
    transcriber: str,
) -> str:
    year = datetime.date.today().year

    return f"""
{title}

Wyrmworks Publishing

Published by Wyrmworks Publishing
https://wyrmworkspublishing.com
© {year} Wyrmworks Publishing
Licensed under CC BY 4.0.
To view a copy of this license, visit
https://creativecommons.org/licenses/by/4.0/

Transcribed {year} into {braille_label} by
{transcriber}

In 1 volume
Braille pages t1 and 1-{body_pages}
""".strip() + "\n"


def prepend_frontmatter_if_needed(
    *,
    body_pages: list[list[str]],
    title: str,
    profile: BrailleProfile,
    display_table: str,
    cells_per_line: int,
    lines_per_page: int,
    threshold: int,
    transcriber: str,
) -> str:
    body_page_count = len(body_pages)
    body_text = pages_to_text(body_pages)

    if body_page_count <= threshold:
        return body_text

    frontmatter_source = make_frontmatter_source(
        title=title,
        braille_label=profile.label,
        body_pages=body_page_count,
        transcriber=transcriber,
    )

    frontmatter_translated = lou_translate(frontmatter_source, profile, display_table)
    frontmatter_lines = wrap_translated_text(frontmatter_translated, cells_per_line)

    # One generated title page for now. When ISBNs arrive, this gets promoted from tiny cart to wagon.
    frontmatter_page = frontmatter_lines[:lines_per_page]

    return "\n".join(frontmatter_page).rstrip() + "\n\f\n" + body_text


def safe_artifact_name(book_main_file: str) -> str:
    safe = re.sub(r"[/\\\s]+", "__", book_main_file)
    safe = re.sub(r"[^A-Za-z0-9_.-]", "", safe)
    return safe or "book"


def find_source_file(book_directory: Path, book_main_file: str) -> Path:
    candidates = [
        book_directory / f"{book_main_file}.md",
        book_directory / f"{book_main_file}.markdown",
    ]

    for candidate in candidates:
        if candidate.exists():
            return candidate

    found = sorted(
        path
        for path in book_directory.rglob("*")
        if path.is_file() and path.suffix.lower() in SUPPORTED_EXTENSIONS
    )

    if len(found) == 1:
        print(
            f"::warning::Expected {book_main_file}.md but found one Markdown file, so using {found[0]}. Lucky, but not a strategy.",
            file=sys.stderr,
        )
        return found[0]

    expected = ", ".join(str(candidate) for candidate in candidates)
    raise FileNotFoundError(
        f"Could not find manuscript main file. Expected one of: {expected}"
    )


def write_outputs(
    *,
    language: str,
    book_main_file: str,
    out_dir: Path,
    title: str,
    plain_text: str,
    segments: list[tuple[str, str]],
    profile: BrailleProfile,
    cells_per_line: int,
    lines_per_page: int,
    frontmatter_page_threshold: int,
    transcriber: str,
) -> None:
    safe_name = safe_artifact_name(book_main_file)

    language_dir = out_dir / language / safe_name
    plain_dir = language_dir / "plain-text"
    brf_dir = language_dir / profile.slug / "brf"
    unicode_dir = language_dir / profile.slug / "unicode"

    plain_dir.mkdir(parents=True, exist_ok=True)
    brf_dir.mkdir(parents=True, exist_ok=True)
    unicode_dir.mkdir(parents=True, exist_ok=True)

    (plain_dir / f"{safe_name}.txt").write_text(plain_text, encoding="utf-8")

    brf_pages = paginate_segments(
        segments,
        profile=profile,
        display_table="en-us-brf.dis",
        cells_per_line=cells_per_line,
        lines_per_page=lines_per_page,
    )

    unicode_pages = paginate_segments(
        segments,
        profile=profile,
        display_table="unicode.dis",
        cells_per_line=cells_per_line,
        lines_per_page=lines_per_page,
    )

    brf_text = prepend_frontmatter_if_needed(
        body_pages=brf_pages,
        title=title,
        profile=profile,
        display_table="en-us-brf.dis",
        cells_per_line=cells_per_line,
        lines_per_page=lines_per_page,
        threshold=frontmatter_page_threshold,
        transcriber=transcriber,
    )

    unicode_text = prepend_frontmatter_if_needed(
        body_pages=unicode_pages,
        title=title,
        profile=profile,
        display_table="unicode.dis",
        cells_per_line=cells_per_line,
        lines_per_page=lines_per_page,
        threshold=frontmatter_page_threshold,
        transcriber=transcriber,
    )

    (brf_dir / f"{safe_name}.brf").write_text(brf_text, encoding="utf-8")
    (unicode_dir / f"{safe_name}.unicode-braille.txt").write_text(
        unicode_text,
        encoding="utf-8",
    )


def build_book(
    *,
    language: str,
    book_directory: Path,
    book_main_file: str,
    out_dir: Path,
    cells_per_line: int,
    lines_per_page: int,
    frontmatter_page_threshold: int,
    transcriber: str,
) -> None:
    source = find_source_file(book_directory, book_main_file)

    print(f"Building braille: {source} [{language}]", flush=True)

    markdown = source.read_text(encoding="utf-8", errors="replace")
    title = extract_first_h1(markdown, source)
    cleaned = clean_markdown(markdown)

    doc = pandoc_json(cleaned)
    segments = document_to_segments(doc, cells_per_line)
    plain_text = normalize_text("\n\n".join(content for _kind, content in segments))

    profiles = select_braille_profiles(language)

    if not profiles:
        raise RuntimeError(
            f"No working Liblouis braille profiles found for {language}."
        )

    for profile in profiles:
        print(f"Using braille profile: {profile.label} ({profile.query})")

        write_outputs(
            language=language,
            book_main_file=book_main_file,
            out_dir=out_dir,
            title=title,
            plain_text=plain_text,
            segments=segments,
            profile=profile,
            cells_per_line=cells_per_line,
            lines_per_page=lines_per_page,
            frontmatter_page_threshold=frontmatter_page_threshold,
            transcriber=transcriber,
        )


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Convert a Free5e Markdown manuscript to draft Liblouis braille artifacts."
    )

    parser.add_argument("--language", required=True)
    parser.add_argument("--book-directory", required=True)
    parser.add_argument("--book-main-file", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--cells-per-line", type=int, default=40)
    parser.add_argument("--lines-per-page", type=int, default=25)
    parser.add_argument("--frontmatter-page-threshold", type=int, default=5)
    parser.add_argument("--transcriber", default="Wyrmworks Publishing via Liblouis")

    args = parser.parse_args()

    book_directory = Path(args.book_directory)
    out_dir = Path(args.out_dir)

    if not book_directory.exists():
        print(f"Book directory does not exist: {book_directory}", file=sys.stderr)
        return 1

    try:
        build_book(
            language=args.language,
            book_directory=book_directory,
            book_main_file=args.book_main_file,
            out_dir=out_dir,
            cells_per_line=args.cells_per_line,
            lines_per_page=args.lines_per_page,
            frontmatter_page_threshold=args.frontmatter_page_threshold,
            transcriber=args.transcriber,
        )
    except Exception as error:
        print(f"Braille conversion failed: {error}", file=sys.stderr)
        return 1

    print("\nGenerated files:")
    for output in sorted(out_dir.rglob("*")):
        if output.is_file():
            print(output)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())