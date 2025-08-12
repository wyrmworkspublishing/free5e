# This tool will extract certain tags from a spell file.
# It does NOT however claim to extract anything from the actual spell text; so things such as damage dice or types, saving throws, etc. have to be added manually.
# It can also not determine, where this spell comes from or whether it was renamed.
import re
import sys
import tomllib

language = sys.argv[1]
spellPath = sys.argv[2]

# Verify the language argument
languageMatch = re.match('^[a-z]{2}-[A-Z]{2}$', language)
if (not languageMatch):
  raise Exception('Invalid language "{}"'.format(language))

with open("spell_tagger.toml", "rb") as f:
    configData = tomllib.load(f)
configForLang = configData.get(language)

if (not configForLang):
  raise Exception('No valid configuration for language {} found'.format(language))

# Prepare the tags dict
tags = {}

# Open the file. If it doesn't exist, we'll get a FileNotFoundError.
with open(spellPath, 'r') as spellFile:
  lines = spellFile.readlines()

  spellName = lines[0].replace('#### ', '').replace('‘', "'").replace('‘', "'").strip()
  tags['[_metadata_:spell_name]'] = spellName
  
  spellNameConfig = configForLang['spell-name']
  # Find the original spell name, if it has one
  for line in lines:
    matchOriginalSpellName = re.search(spellNameConfig['previouslyRegex'], line)
    if (matchOriginalSpellName):
      tags['[_metadata_:spell_original_name]'] = matchOriginalSpellName.group(1)
      break

  # Find the spell level, school, and possibly whether this is a ritual
  spellTypeConfig = configForLang['spell-type']
  for line in lines:
    matchCantrip = re.search(spellTypeConfig['cantripRegex'], line)
    matchLeveledSpell = re.search(spellTypeConfig['leveledSpellRegex'], line)
    matchRitual = re.search(spellTypeConfig['ritualRegex'], line)

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
  castingConfig = configForLang['casting']
  for line in lines:
    matchCastingTime = re.search(castingConfig['castingTimeRegex'], line)
    if (matchCastingTime):
      tags['[_metadata_:casting_time_amount]'] = matchCastingTime.group(1)
      tags['[_metadata_:casting_time_unit]'] = matchCastingTime.group(2)
      if (matchCastingTime.group(3) != None and matchCastingTime.group(3) != ""):
        tags['[_metadata_:casting_time_reaction_trigger]'] = matchCastingTime.group(3)
      break
  # Verify, that we found a casting time
  if (tags.get('[_metadata_:casting_time_amount]', 'none') == 'none'):
    raise Exception('No casting time found!')

  # Find the range of the spell
  rangeConfig = configForLang['range']
  for line in lines:
    matchRange = re.search(rangeConfig['rangeDistanceRegex'], line)
    matchTouchRange = re.search(rangeConfig['rangeTouchRegex'], line)
    matchSelfRange = re.search(rangeConfig['rangeSelfRegex'], line)
    if (matchRange):
      rangeAmount = matchRange.group(1)
      rangeUnit = matchRange.group(2)
      tags['[_metadata_:range]'] = '{} {}'.format(matchRange.group(1), matchRange.group(2))
      tags['[_metadata_:target]'] = "???"
      break
    elif (matchTouchRange):
      tags['[_metadata_:range]'] = rangeConfig['touch']
      tags['[_metadata_:target]'] = "???"
      break
    elif (matchSelfRange):
      tags['[_metadata_:range]'] = rangeConfig['self']
      if (matchSelfRange.group(1) != None):
        tags['[_metadata_:target]'] = matchSelfRange.group(1)
      else:
        tags['[_metadata_:target]'] = "???"
      break
  # Verify, that we found a casting time
  if (tags.get('[_metadata_:range]', 'none') == 'none'):
    raise Exception('No range found!')

  # Find the spell components
  componentsConfig = configForLang['components']
  for line in lines:
    matchComponents = re.search(componentsConfig['componentsRegex'], line)
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
        tags['[_metadata_:components_material_cost]'] = '???'
      break
  # Verify, that we found components
  if (tags.get('[_metadata_:components_verbal]', 'none') == 'none' and tags.get('[_metadata_:components_somatic]', 'none') == 'none' and tags.get('[_metadata_:components_material]', 'none') == 'none'):
    raise Exception('No spell components found!')

  # Find, the spell duration and whether it requires concentration
  durationConfig = configForLang['duration']
  for line in lines:
    matchDurationInstant = re.search(durationConfig['durationInstantRegex'], line)
    matchDuration = re.search(durationConfig['durationNoConcentrationRegex'], line)
    matchDurationConcentration = re.search(durationConfig['durationConcentrationRegex'], line)
    matchDurationOther = re.search(durationConfig['durationOtherRegex'], line)
    if (matchDurationInstant):
      tags['[_metadata_:duration]'] = durationConfig['instantaneous']
      tags['[_metadata_:concentration]'] = 'false'
      break
    elif (matchDuration):
      tags['[_metadata_:duration]'] = '{} {}'.format(matchDuration.group(1), matchDuration.group(2))
      tags['[_metadata_:concentration]'] = 'false'
      break
    elif (matchDurationConcentration):
      tags['[_metadata_:duration]'] = '{} {}'.format(matchDurationConcentration.group(1), matchDurationConcentration.group(2))
      tags['[_metadata_:concentration]'] = 'true'
      break
    elif (matchDurationOther):
      tags['[_metadata_:duration]'] = matchDurationOther.group(1)
      tags['[_metadata_:concentration]'] = 'false'
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
# - spell comparison to the WotC and A5e SRDs

print ('Here are the detected tags for the spell {}:'.format(tags['[_metadata_:spell_name]']))

print ('<!-- markdownlint-disable link-image-reference-definitions -->')
for key, value in tags.items():
  print ('{}:- \"{}\"'.format(key, value))
print('[_metadata_:saving_throw]:- "???"')
print('[_metadata_:saving_throw_success]:- "???"')
print('[_metadata_:damage_formula]:- "???"')
print('[_metadata_:damage_type]:- "???"')
print('[_metadata_:compared_to_wotc_srd_5.1]:- "???"')
print('[_metadata_:compared_to_a5e_srd]:- "???"')
