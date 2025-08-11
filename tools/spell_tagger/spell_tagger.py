# This tool will extract certain tags from a spell file.
# It does NOT however claim to extract anything from the actual spell text; so things such as damage dice or types, saving throws, etc. have to be added manually.
# It can also not determine, where this spell comes from or whether it was renamed.
import re
import sys

spellpath = sys.argv[1]

tags = {}

with open(spellpath, 'r') as spellfile:
  lines = spellfile.readlines()

  spellname = lines[0].replace('#### ', '').replace('‘', "'").replace('‘', "'").strip()
  tags['[_metadata_:spell_name]'] = spellname
  
  # Find the original spell name, if it has one
  for line in lines:
    matchOriginalSpellName = re.search('^<!-- previously "(.*)\" -->$', line)
    if (matchOriginalSpellName):
      tags['[_metadata_:spell_original_name]'] = matchOriginalSpellName.group(1)
      break

  # Find the spell level, school, and possibly whether this is a ritual
  for line in lines:
    matchCantrip = re.search('^_(\w+) cantrip_$', line)
    matchLeveledSpell = re.search('^_(\d).?.?-level (\w+)_$', line)
    matchRitual = re.search('^_(\d).?.?-level (\w+) \(ritual\)_$', line)

    if (matchCantrip):
      tags['[_metadata_:spell_level]'] = '0'
      tags['[_metadata_:spell_school]'] = matchCantrip.group(1).lower()
      tags['[_metadata_:ritual]'] = 'false'
      break
    elif (matchLeveledSpell):
      tags['[_metadata_:spell_level]'] = matchLeveledSpell.group(1)
      tags['[_metadata_:spell_school]'] = matchLeveledSpell.group(2).lower()
      tags['[_metadata_:ritual]'] = 'false'
      break
    elif (matchRitual):
      tags['[_metadata_:spell_level]'] = matchRitual.group(1)
      tags['[_metadata_:spell_school]'] = matchRitual.group(2).lower()
      tags['[_metadata_:ritual]'] = 'true'
      break
  # Verify, that we found a spell level, school, and whether it's a ritual
  if (tags.get('[_metadata_:spell_school]', 'none') == 'none'):
    raise Exception('No spell school or level found!')

  # Find the casting time
  for line in lines:
    matchCastingTime = re.search('^\*\*Casting Time:\*\* (\d+) (\w+) \\\\$', line)
    if (matchCastingTime):
      tags['[_metadata_:casting_time_amount]'] = matchCastingTime.group(1)
      tags['[_metadata_:casting_time_unit]'] = matchCastingTime.group(2)
      break;
  # Verify, that we found a casting time
  if (tags.get('[_metadata_:casting_time_amount]', 'none') == 'none'):
    raise Exception('No casting time found!')

  # Find the range of the spell
  for line in lines:
    matchRange = re.search('^\*\*Range:\*\* (\d+) (\w+) \\\\$', line)
    if (matchRange):
      rangeAmount = matchRange.group(1)
      rangeUnit = matchRange.group(2)
      tags['[_metadata_:range]'] = '{} {}'.format(matchRange.group(1), matchRange.group(2))
      break;
  # Verify, that we found a casting time
  if (tags.get('[_metadata_:range]', 'none') == 'none'):
    raise Exception('No range found!')

  # Find the spell components
  for line in lines:
    matchComponents = re.search('^\*\*Components:\*\* ([VSM])[,\s]{0,2}([VSM])?[,\s]{0,2}([VSM])?[,\s]{0,2}\s?\((.*)?\) \\\\$', line)
    # Initially set all of these to false; we'll then set those to true, that we actually have.
    tags['[_metadata_:components_verbal]'] = 'false'
    tags['[_metadata_:components_somatic]'] = 'false'
    tags['[_metadata_:components_material]'] = 'false'

    if (matchComponents):
      componentGroups = len(matchComponents.groups())
      if ((componentGroups >= 1 and matchComponents.group(1) == 'V') or (componentGroups >= 2 and matchComponents.group(2) == 'V') or (componentGroups >= 3 and matchComponents.group(3) == 'V')):
        tags['[_metadata_:components_verbal]'] = 'true'
      if ((componentGroups >= 1 and matchComponents.group(1) == 'S') or (componentGroups >= 2 and matchComponents.group(2) == 'S') or (componentGroups >= 3 and matchComponents.group(3) == 'S')):
        tags['[_metadata_:components_somatic]'] = 'true'
      if ((componentGroups >= 1 and matchComponents.group(1) == 'M') or (componentGroups >= 2 and matchComponents.group(2) == 'M') or (componentGroups >= 3 and matchComponents.group(3) == 'M')):
        tags['[_metadata_:components_material]'] = 'true'
      if (tags.get('[_metadata_:components_material]', 'false') == 'true'):
        tags['[_metadata_:components_material_description]'] = matchComponents.group(4)
      break;
  # Verify, that we found components
  if (tags.get('[_metadata_:components_verbal]', 'none') == 'none' and tags.get('[_metadata_:components_somatic]', 'none') == 'none' and tags.get('[_metadata_:components_material]', 'none') == 'none'):
    raise Exception('No spell components found!')

  # Find, the spell duration and whether it requires concentration
  for line in lines:
    matchDurationInstant = re.search('^\*\*Duration:\*\* Instantaneous$', line)
    matchDuration = re.search('^\*\*Duration:\*\* (\d+) (\w+)$', line)
    matchDurationConcentration = re.search('^\*\*Duration:\*\* Concentration, up to (\d+) (\w+)$', line)
    if (matchDurationInstant):
      tags['[_metadata_:duration]'] = 'Instantaneous'
      tags['[_metadata_:concentration]'] = 'false'
      break;
    elif (matchDuration):
      tags['[_metadata_:duration]'] = '{} {}'.format(matchDuration.group(1), matchDuration.group(2))
      tags['[_metadata_:concentration]'] = 'false'
      break;
    elif (matchDurationConcentration):
      tags['[_metadata_:duration]'] = '{} {}'.format(matchDurationConcentration.group(1), matchDurationConcentration.group(2))
      tags['[_metadata_:concentration]'] = 'true'
      break;
  # Verify, that we found a duration
  if (tags.get('[_metadata_:duration]', 'none') == 'none'):
    raise Exception('No duration found!')

# Things, that cannot be determined automatically:
# - target
# - material component cost
# - saving throw
# - effect on successful saving throw
# - damage formula
# - damage type
# - spell origin

print ('Here are the detected tags for the spell {}:'.format(tags['[_metadata_:spell_name]']))

for key, value in tags.items():
  print ('{}:- \"{}\"'.format(key, value))
