import csv
import os
import re
import sys

spellpath = sys.argv[1]
outfile = sys.argv[2]
print ('Reading spell files from directory {}, writing to file {}\n'.format(spellpath, outfile))

spells = []

for root, dirs, files in os.walk(spellpath):
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

      for line in lines:
        match = re.search('^\[_metadata_:([\w_\.]+)\]:-\s*"([^"]*)"', line)
        if match:
          print('  {:35s} -> {}'.format(match.group(1), match.group(2)))
          spelldict[match.group(1)] = match.group(2)

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
    'original spell name'
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
      spell.get('spell_original_name', '')
    ])
