<p align="center">
<img src="assets/images/GMDex_wide.png" alt="GMDex logo" width="400" hspace="60">

<img src="assets/images/GMDex.png" alt="GMDex logo" width="200">
</p>

GMDex is a tool to help GM's of Dungeons and Dragons 5th Edition manage their tables. It features a creature database preloaded with the SRD creatures, a custom creature creator, a player creator and database, an encounter builder, a combat tracker, and a json importer so you can bring your own monster library. It is built primarily for Windows, but does feature a mobile version, Linux and Mac to come. It is completely offline and stores the database locally so you always have access to your data. <br><br>

## Features

- Combat
  - Condition tracking - all combatants include a Conditions expansion to track all official statuses
  - Active turn highlighter option
  - Bring up creature statblocks and notes mid encounter
  - Pop out a live player-facing initiative list into a separate desktop window, supported on Windows, Linux, and macOS
  - Track encounter specific notes
  - The encounter place, including current hitpoints, intiative place, and conditions will be saved on Save & Exit in case a session ends mid combat
  - Live edits - edit your encounter in the middle of running it to add/remove combatants

- Encounter building
  - The database includes all SRD creatures, and you can add your own. All creatures can be added to an encounter
  - Add conditions in the encounter builder
  - Set intiative ahead of time
  - Up the quantity on a creature for multiple of the same creature to move on the same initiative or add multiple of the same creature for different initiative per creature
  - XP calculator included to help guide appropriate encounter building based on the players and creatures added to the combat
    - Both standard 2014 5th edition rules and the Flee, Mortals! (by MCDM) rules are included. This setting can be changed in the settings page
  - Add any notes you have for the encounter directly to it
- Bestiary
  - All SRD creatures are included, and you can import your own using the specified json format
  - Create your own custom creatures in the app
  - Copy and edit all creatures in the app, official and custom creatures
  - Add creature specific notes to any creature
- Player Database
  - Create and track players, including
    - Name
    - Class
    - Level
    - Hitpoints
    - Armor Class
    - Passive Perception
  - Players can be edited, copied, and created new

## Database backups

Use **Export Entire Database** in Settings to create a portable JSON backup, and **Import Entire Database** to replace the current local data from that backup. The backup includes players, creatures, encounters, notes, and all related records. Importing replaces all current database records; export a backup before importing if you may need to restore them.

The JSON format is versioned and retains record IDs so encounter references remain intact:

```json
{
  "format": "gmdex-database-backup",
  "version": 1,
  "databaseSchemaVersion": 12,
  "exportedAt": "2026-11-01T10:18:55.141Z",
  "tables": {
    "legendary_groups": [],
    "players": [],
    "encounters": [],
    "encounter_creatures": [],
    "encounter_players": [],
    "creature_actions": [],
    "creature_traits": [],
    "creature_spellcastings": [],
    "creature_spells": [],
    "creature_saves": [],
    "creature_skills": [],
    "creature_senses": [],
    "creature_languages": [],
    "creature_environments": [],
    "legendary_group_entries": [],
    "creatures": [],
    "notes": []
  }
}
```

Each table value is an array of database rows. The example lists every table; the exported backup includes the row data for each. Row IDs are retained so encounter references remain intact, and date columns use ISO-8601 strings. Import accepts backups from this or an older database schema version supported by the app.

## Desktop Screenshots

![image](assets/homepage.png)

![image](assets/creaturelookup.png)

![image](assets/creaturecreate.png)

![image](assets/playerdatabase.png)

![image](assets/encounterbuilder.png)

![image](assets/encounterdatabase.png)

![image](assets/encounterrunner.png)

![image](assets/playerinitiative.png)

![image](assets/settingspage.png)

![image](assets/playercreator.png)

![image](assets/spelldatabase.png)

## Mobile Screenshots

<table>
  <tr>
    <td><img src="assets/mobilehome.png" width="160" alt="Mobile homepage"></td>
    <td><img src="assets/mobilebestiary.png" width="160" alt="Mobile bestiary"></td>
    <td><img src="assets/mobilecreaturecreate.png" width="160" alt="Mobile creature creator"></td>
    <td><img src="assets/mobileplayer.png" width="160" alt="Mobile player page"></td>
  </tr>
  <tr>
    <td><img src="assets/mobileencounter.png" width="160" alt="Mobile encounter builder"></td>
    <td><img src="assets/mobileencounterdb.png" width="160" alt="Mobile encounter database"></td>
    <td><img src="assets/mobileruncombat.png" width="160" alt="Mobile combat runner"></td>
    <td><img src="assets/mobilesettings.png" width="160" alt="Mobile settings"></td>
  </tr>
  <tr>
    <td><img src="assets/mobilestatblockcombat.png" width="160" alt="Mobile encounter builder"></td>
    <td><img src="assets/mobileplayercreate.png" width="160" alt="Mobile encounter database"></td>
    <td><img src="assets/mobilespell.png" width="160" alt="Mobile combat runner"></td>
    <td><img src="assets/mobilespelldb.png" width="160" alt="Mobile settings"></td>
  </tr>
</table>

## Json Structure

Creature import files need to be JSON objects with a top-level `monster` array. Each item in that array describes the creature. The importer requires a creature name, armor class (`ac`), and hit points (`hp`); the other fields are optional. `ac` can be a number or an array, and `hp` should be an object with an `average` value and optional `formula`.

See [template.json](template.json) for a complete, editable example. It includes common stat block fields, a trait, an action, and spellcasting. Remove optional fields you don't need, or add more creature objects to the `monster` array. Creature entries use the 5etools-style bestiary format; traits and actions use `name` and `entries` fields.

## Roadmap

- Add spells
- Possibly allow user specified location for database syncing across platforms
  - Right now you have to export your entire database and move that across platforms manually and import it

### SRD License Information

This work includes material taken from the System Reference Document 5.1 (“SRD 5.1”) by Wizards of the Coast LLC and available at <https://dnd.wizards.com/resources/systems-reference-document>. The SRD 5.1 is licensed under the Creative Commons Attribution 4.0 International License available at <https://creativecommons.org/licenses/by/4.0/legalcode>.
