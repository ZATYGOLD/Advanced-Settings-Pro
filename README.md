# Zatygold's Advanced Settings Pro

A Sid Meier's Civilization VII mod that expands game setup for single player and multiplayer. It adds extra options to the Advanced Settings menu, letting you fine-tune systems that normally are not adjustable.

## Version History

### 0.8.0

- Added an Age Pace setting to Game Settings: Standard, Balanced (age caps 153/166/196, the Balanced progress curve, High technology and civic costs), Multiplayer (age caps 140/155/190, the Balanced progress curve, technologies +35/+50/+75% and civics +45/+60/+85% by age, Slow growth, Fast roads with Express railroads in Modern, victory projects +20%), or Custom. A preset writes its values into the Defaults settings on the Pace tab; changing one afterwards switches the preset to Custom
- Per-age Age Length rows now take an exact age progress total (90 to 300), and per-age Technology and Civic Cost rows a percentage (-25% to +100%); Age Progress Rate gains Balanced, City Growth gains Slower, Roads gains Express, and Victory Project Cost gains +20%
- Cost settings are now named Low, Standard, High, and Double; the Default option of the other settings is now called Standard
- Added a Pace tab to the single-player Advanced Settings screen with a Defaults group (Age Length, Age Progress Rate, Technology Cost, Civic Cost, City Growth, Roads, and Victory Project Cost) and an Antiquity, Exploration, and Modern group holding each setting's per-age row, used when the setting is Custom (Victory Project Cost is Modern-only)
- Added a Map tab to the single-player Advanced Settings screen, holding the map, natural wonder, and disaster settings; General keeps the game and crisis settings
- Natural Wonders now sits in Map Settings right after Map Size; the per-wonder toggles keep their own Natural Wonder Selection group
- Added Nachi Falls and Seongsan Ilchulbong (Japan & Korea Wonders) to Natural Wonder Selection, for 22 wonders in total
- Split the game's disaster and crisis settings: a Disaster Settings group on the Map tab and a Crisis Settings group on General
- Added a Crises setting (Enabled or Disabled) that drives the game's per-crisis selection, now titled Crisis Selection
- Replaced Crisis Speed with Crisis Timing: Early, Standard, or Late, showing Disabled while Crises is Disabled
- Disaster Frequency now offers Custom with separate Antiquity, Exploration, and Modern frequencies, each Disabled, Light, Moderate, or Catastrophic
- Triumph Set gains Custom with separate Antiquity, Exploration, and Modern Triumph Sets chosen from the game's sets
- Added Major and Minor Memento dropdowns for AI players on the Player tab, beside Leader and Civilization, each with None and Random options; Random rolls a fresh memento every game
- Added a Random button beside the Game Random Seed and Map Random Seed fields
- Custom settlement limits now run 1 to 25, then 30 to 75 in steps of 5, with one shared file per value instead of one per age
- Unit costs are now Low (25% cheaper), Standard, High (50% more), or Double (100% more)
- Lakes, Rivers, and Mountains drop their Disabled option and label their default Standard
- Raging Independent Aggression is stronger: triple boldness, warriors spawn three times as fast, and 3/5/7 starting units per age
- Initial Independent Hostility moved to the top of Independent Power Settings
- Every setting's tooltip now shows its own value line under the setting's description instead of repeating the description or listing every tier
- The conflict guard also recognises conflicting mods by the setup settings they add, so renaming or re-ordering a mod no longer bypasses it; an unidentified mod is reported by those settings
- Fixed multiplayer-only settings appearing in single-player setup

### 0.7.4

- Age Length descriptions now list the resulting age progress points for every game speed (Online 2.0 through Marathon 2.0), so the exact target for ending an age is visible before you start
- Reworked the mod conflict guard: enabled conflicting mods are now disabled automatically on load with no startup dialog; instead, the conflict dialog appears when you click Continue, New Game, Load Game, or Multiplayer while a conflict is still active, holding that action until it is resolved
- Optimized the conflict guard so its main menu hook does no work outside the guarded buttons

### 0.7.3

- Merged the Initial Independent Units Amount setting into Independent Aggression: Calm now also reduces starting independent units and Raging increases them
- Added a Mountains setting (Disabled, Less, Default, or More) controlling mountain generation; Disabled applies to all map types, while Less and More apply to the seven non-Voronoi maps
- Added an Independent Aggression setting (Calm, Default, or Raging) that scales how boldly and quickly Independent Powers raid and attack

### 0.7.2

- Extended the Age Length setting with Brief (90) and Doubled (280) options alongside the existing three
- Fixed Gullfoss, Iguazu Falls, and Valley of Flowers rarely spawning by relaxing their biome and coast placement requirements

### 0.7.1

- Added a Custom option to Settlement Limit with individual Antiquity, Exploration, and Modern limits, each adjustable from 1 to 50
- The per-age settlement limits follow the curated Less, Default, and More values, and editing one switches the Settlement Limit to Custom automatically
- Renamed the Natural Wonders count option None to Disabled and moved the setting to Map Settings
- The Natural Wonders count and the per-wonder Selection toggles now stay in sync: Disabled turns every wonder off, leaving Disabled turns them back on, disabling every wonder sets the count to Disabled, and a selection too small for the chosen count is reset
- Added a mod conflict guard: a main menu panel lists enabled conflicting mods with a one-click disable, and conflicts are also disabled automatically when starting, loading, or joining a game
- Added a Rivers setting (Disabled, Less, Default, or More) controlling how many rivers are generated, supported on all eleven standard map types
- Added a Disabled option to the Lakes setting that skips lake generation entirely
- Added a Civilian Unit Cost setting mirroring Military Unit Cost
- Added an Expensive option (50% more expensive) to both unit cost settings
- Added two new game speeds: Online 2.0 (150% faster than Standard) and Marathon 2.0 (400% slower than Standard)

### 0.6.1

- Added Natural Wonder Settings and Natural Wonder Selection categories: a wonder count setting plus per-wonder Enabled/Disabled toggles for full control over which natural wonders can appear
- Added localized text for all 12 languages supported by the game, with natural wonder names drawn from the game's official translations

### 0.6.0

- Fixed Treasure Convoy Speed not applying at sea; movement is now adjusted on land and at sea through the fleet's unit ability
- Fixed Settler Speed embarked bonus and extended it to unique settler replacements
- Fixed default values for seven settings in the setup screen
- Setting descriptions now display correctly in the current game UI
- Disaster disabling no longer relies on a fixed event list, covering disasters added in future patches
- Removed Ocean Width, superseded by the base game's Sea Level setting
- Reorganized the project to match the game's file conventions; gameplay data is now pure SQL
- License changed to GPL-3.0

### 0.5.0

- Initial release

## Settings

- Single Player No Age Transitions: Enabled or Disabled
- Game Random Seed and Map Random Seed: a Random button beside each field rolls a new seed (single player)
- Game Speed: adds Online 2.0 (150% faster than Standard) and Marathon 2.0 (400% slower than Standard)
- Age Length: the game's own setting, moved to Defaults on the Pace tab and extended with Brief (90), Doubled (280), and Custom; it drives the per-age rows (any total from 90 to 300), and a per-age change shows Custom; switching it off Custom returns every other Defaults setting to Standard
- Age Pace (Game Settings): Standard, Balanced, Multiplayer, or Custom (written into the Defaults settings on the Pace tab)
- Age Progress Rate: Slow, Standard, Balanced, Fast, or Custom (milestone and future tech/civic points x0.5 / x1 / the Balanced curve / x1.5)
- Technology Cost and Civic Cost: Low (25% cheaper), Standard, High (50% more), Double (100% more), or Custom (per-age rows pick -25%, +35% to +100%)
- City Growth: Slower, Slow, Standard, Fast, or Custom
- Roads: Standard, Fast (25% less movement cost), Express (25% less on roads, 50% less on railroads), Faster (50% less), or Custom
- Victory Project Cost: Low, Standard, +20%, High, or Double (Modern Age victory and legacy projects)
- Antiquity, Exploration, and Modern rows for each Custom pacing setting above
- Disaster Frequency: Disabled, Light, Moderate, Catastrophic, or Custom
- Antiquity, Exploration, and Modern disaster frequency: Disabled, Light, Moderate, or Catastrophic each, applied when Disaster Frequency is set to Custom
- Settler Speed: Slow, Standard, or Fast
- Treasure Convoy Speed: Slow, Standard, or Fast
- Military Unit Cost: Low (25% cheaper), Standard, High (50% more), or Double (100% more)
- Civilian Unit Cost: Low (25% cheaper), Standard, High (50% more), or Double (100% more)
- Natural Wonders: Disabled, Half, Standard, More, or Double
- Natural Wonder Selection: Enabled or Disabled for each of the 22 natural wonders, including DLC wonders
- Lakes: Less, Standard, or More
- Rivers: Less, Standard, or More
- Mountains: Less, Standard, or More
- Crises: Enabled or Disabled, driving the game's per-crisis selection
- Crisis Timing: Early, Standard, or Late (Disabled while Crises is Disabled)
- Settlement Limit: Less, Standard, More, or Custom
- Antiquity, Exploration, and Modern settlement limits: 1 to 25, then 30 to 75 in steps of 5, applied when Settlement Limit is set to Custom
- Settlement Distance: Less, Standard, or More
- Independent Amount: None, Less, Standard, or More
- Independent Spacing: Less, Standard, or More
- Independent Aggression: Calm, Standard, or Raging (raid boldness plus starting independent units)
- AI Mementos (Player tab, single player): Major and Minor Memento dropdowns on each AI player's row beside Leader and Civilization, each with a Random option rolled afresh every game
- Triumph Set: adds Custom to the game's setting, with an Antiquity, Exploration, and Modern Triumph Set each choosable from the game's sets

The conflict guard recognises conflicting mods by their id and by the setup settings they add to the game, so renaming a mod does not bypass it.

All settings are chosen at game creation and apply for the full game.

In single player, the Advanced Settings screen gains a Pace tab (Defaults pacing settings plus a group per age) and a Map tab between General and Player; the Map tab holds the map, natural wonder, and disaster settings, while the crisis settings move into their own Crisis Settings group on General and Initial Independent Hostility joins the Independent Power settings; multiplayer keeps the game's standard layout.

## Project Structure

```
advanced-settings-pro.modinfo   Mod manifest: setup criteria and action groups
config/                         Setup screen parameters (shell scope)
data/                           Gameplay adjustments (game scope), grouped by system
l10n/                           Localized text for the 11 non-English languages
maps/                           Map script copies that apply the Rivers setting
text/                           English source strings and shared localization data
ui/                             Shell scripts: mod conflict guard and setup rule sync
```

## Requirements

Base game with the Antiquity, Exploration, and Modern age modules.

## Languages

English, German, Spanish, French, Italian, Japanese, Korean, Polish, Brazilian Portuguese, Russian, Simplified Chinese, and Traditional Chinese.

English source strings live in the text directory; all other languages are provided as localization files under the l10n directory, matching the game's own convention.

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.
