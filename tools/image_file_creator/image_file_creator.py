import csv
import os
from pathlib import Path
import re
import sys

csv_path = sys.argv[1]
language = sys.argv[2]

print('Reading image CSV file at path {}...\n'.format(csv_path))

# Read the CSV file and store the image information in a list of dictionaries
image_information = []
with open(csv_path, "r") as csv_file:
    image_data = csv.reader(csv_file)
    header_encountered = False
    index_order = None
    index_filename = None
    index_section = None
    index_chapter_directory = None
    index_alt_text = None
    index_caption = None
    index_artist = None
    index_artist_contact_portfolio = None
    index_rights = None
    index_file_path = None
    index_width = None
    index_alignment = None
    for row in image_data:
        # Skip the header row, which will be the first row in each CSV file
        if not header_encountered:
            for index, column_name in enumerate(row):
                if column_name == "Order":
                    index_order = index
                elif column_name == "Filename":
                    index_filename = index
                elif column_name == "Section":
                    index_section = index
                elif column_name == "Chapter directory":
                    index_chapter_directory = index
                elif column_name == "Alt Text":
                    index_alt_text = index
                elif column_name == "Caption":
                    index_caption = index
                elif column_name == "Artist":
                    index_artist = index
                elif column_name == "Artist Contact/Portfolio":
                    index_artist_contact_portfolio = index
                elif column_name == "Rights":
                    index_rights = index
                elif column_name == "File path":
                    index_file_path = index
                elif column_name == "Width":
                    index_width = index
                elif column_name == "Alignment":
                    index_alignment = index
            header_encountered = True
            continue
        # Read the data from each row and store it in a dictionary
        if index_order is not None:
          order = row[index_order]
        else:
          order = None
        if index_filename is not None:
          filename = row[index_filename]
        else:
          # Skip files without a file name
          continue
        if index_section is not None:
          section = row[index_section]
        else:
          section = None
        if index_chapter_directory is not None:
          chapter_directory = row[index_chapter_directory]
        else:
          chapter_directory = None
        if index_alt_text is not None:
          alt_text = row[index_alt_text]
        else:
          alt_text = None
        if index_caption is not None:
          caption = row[index_caption]
        else:
          caption = None
        if index_artist is not None:
          artist = row[index_artist]
        else:
          artist = None
        if index_artist_contact_portfolio is not None:
          artist_contact_portfolio = row[index_artist_contact_portfolio]
        else:
          artist_contact_portfolio = None
        if index_rights is not None:
          rights = row[index_rights]
        else:
          rights = None
        if index_file_path is not None:
          file_path = row[index_file_path]
        if index_width is not None:
          width = row[index_width]
        if index_alignment is not None:
          alignment = row[index_alignment]
        else:
          # Skip files without a file path
          continue  
        image_information.append({
            'order': order,
            'filename': filename,
            'section': section,
            'chapter_directory': chapter_directory,
            'alt_text': alt_text,
            'caption': caption,
            'artist': artist,
            'artist_contact_portfolio': artist_contact_portfolio,
            'rights': rights,
            'file_path': file_path,
            'width': width,
            'alignment': alignment,
        })

# A method for creating the Markdown wrapper file for an image
def create_md_file_content(image_info):
    if (image_info['file_path'] and image_info['alt_text'] and image_info['caption']):
        md_content = f"![{image_info['alt_text']}](\"../../../../../../{image_info['file_path']}\" \"{image_info['caption']}\")"
    elif (image_info['file_path'] and image_info['alt_text']):
        md_content = f"![{image_info['alt_text']}](\"../../../../../../{image_info['file_path']}\")"
    elif (image_info['file_path']):
        md_content = f"![](\"../../../../../../{image_info['file_path']}\")"
    else:
        md_content = ""
    if (image_info['caption']):
        md_content += f"\n_{image_info['caption']}_"
    return md_content

# A method for creating the AsciiDoc wrapper file for an image
def create_adoc_file_content(image_info):
    adoc_content = ":imagesdir: ../../../../../..\n\n"
    adoc_content += "// tag::image[]\n"

    if (image_info['caption']):
        adoc_content += f".{image_info['caption']}\n"

    filename = image_info['filename']
    clean_filename = re.sub(r'[^a-zA-Z0-9_.-]', '_', filename).strip()
    image_id = f"#img-{clean_filename}"
    adoc_content += f"[{image_id}]\n"

    if (image_info['file_path'] and image_info['alt_text']):
        adoc_content += f"image::{image_info['file_path']}"
    elif (image_info['file_path']):
        adoc_content += f"image::{image_info['file_path']}"

    adoc_content += f"[\"{image_info['alt_text']}\""
    roles = []
    if (image_info['width'] == "half"):
       roles.append("half-width")
       adoc_content += ", pdfwidth=50%, scalewidth=50%"
    elif (image_info['width'] == "third"):
      roles.append("third-width")
      adoc_content += ", pdfwidth=33%, scalewidth=33%"
    if (image_info['alignment']):
       roles.append("related")
       adoc_content += f", float={image_info['alignment']}"
    if roles:
       adoc_content += f", role=\"{' '.join(roles)}\""
    adoc_content += "]"

    adoc_content += "\n// end::image[]\n"
    return adoc_content

# The following loop will create all of the Markdown and AsciiDoc wrapper files for the images in the CSV file, using the image information that was read from the CSV file
target_base_directory = os.path.dirname(csv_path)
for image in image_information:
    image_file_path = image['file_path']
    image_directory_path = os.path.dirname(image_file_path)
    target_directory = os.path.join(target_base_directory, image_directory_path)

    if not os.path.isdir(target_directory):
        os.makedirs(target_directory)

    filename_without_extension = Path(image_file_path).stem.replace(" ", "_").replace("-", "_")

    md_path = os.path.join(target_directory, filename_without_extension + ".md")
    md_content = create_md_file_content(image)
    with (open(md_path, "w") as md_file):
        md_file.write(md_content)

    adoc_path = os.path.join(target_directory, filename_without_extension + ".adoc")
    adoc_content = create_adoc_file_content(image)
    with (open(adoc_path, "w") as adoc_file):
        adoc_file.write(adoc_content)

# TODO Create a list of all images per artist (including the legal rights) and link to their contact / portfolio
