import csv
import os
import re
import sys
import tomllib

language = sys.argv[1]
spellpath = sys.argv[2]
outfile = sys.argv[3]

dir_path = os.path.dirname(os.path.realpath(__file__))
with open(dir_path + '/spell_extractor.toml', 'rb') as f:
    configData = tomllib.load(f)
configForLang = configData.get(language)
regexConfigs = configForLang['regexes']

print ('Reading spell files from directory {}, writing to file {}\n'.format(spellpath, outfile))

spells = []

for root, dirs, files in os.walk(spellpath):
  if (root == spellpath):
    continue
  print ('Found {} spell files in {}'.format(len(files), root))

  for file in files:
    print("Processing file {}...".format(file))
    if (not file.endswith('.md')):
      continue
    filepath = os.path.join(root, file)
    with open(filepath, 'r') as spellfile:
      spelldict = {}

      lines = spellfile.readlines()
      spellname = lines[0].replace('#### ', '').replace('‘', "'").replace('‘', "'").strip()
      print('  spell_name                          -> {}'.format(spellname))
      spelldict['spell_name'] = spellname

      duration_line = None;
      for line_number, line in enumerate(lines):
        matchMetadata = re.search(regexConfigs['metadataRegex'], line)
        matchDuration = re.search(regexConfigs['durationRegex'], line)
        if matchMetadata:
          print('  {:35s} -> {}'.format(matchMetadata.group(1), matchMetadata.group(2)))
          spelldict[matchMetadata.group(1)] = matchMetadata.group(2)
        elif matchDuration:
          duration_line = line_number

      if (duration_line == None):
        raise Exception('No start line for duration found in file "{}"'.format(file))

      spell_text_list = []
      at_higher_levels_start_line = None;
      for line_number, line in enumerate(lines):
        matchAtHigherLevels = re.search(regexConfigs['atHigherLevelsRegex'], line)
        matchCantripDamageIncrease = re.search(regexConfigs['cantripDamageIncreaseRegex'], line)
        matchCantripBeamIncrease = re.search(regexConfigs['cantripBeamIncreaseRegex'], line)
        if (line_number < duration_line + 2):
          continue
        elif matchAtHigherLevels:
          # We don't need the "At higher levels" part to be included
          at_higher_levels_start_line = line_number + 1
          continue
        elif matchCantripDamageIncrease or matchCantripBeamIncrease:
          at_higher_levels_start_line = line_number
        elif at_higher_levels_start_line == None:
          spell_text = line.replace('\n', '\\n')
          spell_text_list.append(spell_text)
      spelldict['spell_text'] = ''.join(spell_text_list).removesuffix('\\n').removesuffix('\\n')
      print('  spell_text                          -> {}'.format(spelldict['spell_text']))

      at_higher_levels_list = []
      if (at_higher_levels_start_line):
        for line_number, line in enumerate(lines):
          if (line_number < at_higher_levels_start_line):
            continue
          else:
            at_higher_levels_text = line.replace('\n', '\\n')
            at_higher_levels_list.append(at_higher_levels_text)
        spelldict['spell_at_higher_levels'] = ''.join(at_higher_levels_list).removesuffix('\\n')

      if len(spelldict) > 1:
        spells.append(spelldict)
    print('\n')

sortedSpells = sorted(spells, key=lambda d: d['spell_name'])

with (open(outfile, 'w', newline='')) as csvfile:
  csvwriter = csv.writer(
    csvfile,
    delimiter='\t', # The material component descriptions may contain commas or semicolons, the two most common separators. So we'll have to use a less common one.
    quotechar='"',
    quoting=csv.QUOTE_NONNUMERIC
  )
  csvwriter.writerow([
    'spell name',
    'spell school',
    'spell level',
    'casting time amount',
    'casting time unit',
    'reaction trigger',
    'ritual spell',
    'range',
    'target',
    'has verbal component',
    'has somatic component',
    'has material component',
    'material component description',
    'material component cost',
    'requires concentration',
    'spell duration',
    'required saving throw',
    'effect on successful saving throw',
    'damage formula',
    'damage type',
    'healing formula',
    'compared to the wotc srd',
    'compared to the a5e srd',
    'original spell name',
    'spell text',
    'at higher levels'
  ])

  for spell in sortedSpells:
    csvwriter.writerow([
      spell.get('spell_name'),
      spell.get('spell_school'),
      spell.get('spell_level'),
      spell.get('casting_time_amount'),
      spell.get('casting_time_unit'),
      spell.get('casting_time_reaction_trigger'),
      spell.get('ritual', 'false'),
      spell.get('range'),
      spell.get('target', ''),
      spell.get('components_verbal', 'false'),
      spell.get('components_somatic', 'false'),
      spell.get('components_material', 'false'),
      spell.get('components_material_description', ''),
      spell.get('components_material_cost', ''),
      spell.get('concentration', 'false'),
      spell.get('duration'),
      spell.get('saving_throw', 'None'),
      spell.get('saving_throw_success', ''),
      spell.get('damage_formula', ''),
      spell.get('damage_type', ''),
      spell.get('healing_formula', ''),
      spell.get('compared_to_wotc_srd_5.1', "unknown"),
      spell.get('compared_to_a5e_srd', "unknown"),
      spell.get('spell_original_name', ''),
      spell.get('spell_text'),
      spell.get('spell_at_higher_levels', '')
    ])
