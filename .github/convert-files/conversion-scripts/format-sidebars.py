import re
import sys

adoc_file = sys.argv[1]

with open (adoc_file, 'r') as adoc:
  sidebar_found = False
  title_printed = False
  for line in adoc:
    if not sidebar_found:
      if line == '// style:sidebar\n':
          sidebar_found = True
      else:
        print(line, end='')
    else:
      if not title_printed:
        matchTitle = re.search('^[*](.*)[*] \+', line)
        if matchTitle:
          print('.' + matchTitle.group(1))
          print('****')
          title_printed = True
        elif (line == '\n' or line == '____\n'):
          continue
        else:
          raise Exception('Unexpected line: "' + line + '" found after sidebar start but before the title')
      else:
        if line == '____\n':
          print('****')
          sidebar_found = False
          title_printed = False
        else:
          print(line, end='')
