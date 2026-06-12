import json

MONSTERS_PATH = 'assets/monsters.json'
BESTIARY_PATH = 'assets/bestiary-srd.json'
OUT_PATH = 'assets/bestiary-srd.filtered.json'


def blankify(value):
    if isinstance(value, dict):
        return {k: blankify(v) for k, v in value.items()}
    if isinstance(value, list):
        return []
    # primitives -> empty string
    return ""


with open(MONSTERS_PATH, 'r', encoding='utf-8') as f:
    monsters = json.load(f)

monster_names = set()
for m in monsters:
    name = m.get('name')
    if name:
        monster_names.add(name.strip().lower())

with open(BESTIARY_PATH, 'r', encoding='utf-8') as f:
    bestiary = json.load(f)

if 'monster' not in bestiary:
    print('No monster key in bestiary; aborting')
    raise SystemExit(1)

filtered = {'monster': []}
for entry in bestiary['monster']:
    name = entry.get('name','').strip().lower()
    if name in monster_names:
        filtered['monster'].append(entry)
    else:
        # retain structure but blank values
        new_entry = blankify(entry)
        filtered['monster'].append(new_entry)

with open(OUT_PATH, 'w', encoding='utf-8') as f:
    json.dump(filtered, f, ensure_ascii=False, indent=4)

print('Wrote', OUT_PATH)
