#!/usr/bin/env python 

import sys
import json

with open(sys.argv[1], 'r') as f:
  data = json.load(f)
  lib_type = data['expected_format']

if lib_type in ['U', 'IU']:
    strandedness = 'unstranded'
elif lib_type in ['SF', 'ISF']:
    strandedness = 'FR' if lib_type == 'ISF' else 'F'
elif lib_type in ['SR', 'ISR']:
    strandedness = 'RF' if lib_type == 'ISR' else 'R'
print(strandedness)
