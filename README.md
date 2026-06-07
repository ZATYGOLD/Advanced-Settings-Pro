# Zatygold's Advanced Settings Pro

A Sid Meier's Civilization VII mod that expands game setup for single player and multiplayer. It adds extra options to the Advanced Settings menu, letting you fine-tune systems that normally are not adjustable.

## Version History

### 0.7.0

- Added a Custom option to Settlement Limit with individual Antiquity, Exploration, and Modern limits, each adjustable from 1 to 50
- The per-age settlement limits follow the curated Less, Default, and More values, and editing one switches the Settlement Limit to Custom automatically
- Renamed the Natural Wonders count option None to Disabled and moved the setting to Map Settings
- The Natural Wonders count and the per-wonder Selection toggles now stay in sync: Disabled turns every wonder off, leaving Disabled turns them back on, disabling every wonder sets the count to Disabled, and a selection too small for the chosen count is reset
- Added a mod conflict guard: a main menu panel lists enabled conflicting mods with a one-click disable, and conflicts are also disabled automatically when starting, loading, or joining a game

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
- Disaster Frequency: Disabled, Light, Moderate, or Catastrophic
- Settler Speed: Slow, Default, or Fast
- Treasure Convoy Speed: Slow, Default, or Fast
- Military Unit Cost: Cheaper, Default, or Expensive
- Natural Wonders: Disabled, Half, Default, More, or Double
- Natural Wonder Selection: Enabled or Disabled for each of the 20 natural wonders, including DLC wonders
- Lakes: Less, Default, or More
- Crisis Speed: Crawl, Slow, Default, Quick, or Fast
- Settlement Limit: Less, Default, More, or Custom
- Antiquity, Exploration, and Modern settlement limits: 1 to 50 each, applied when Settlement Limit is set to Custom
- Settlement Distance: Less, Default, or More
- Initial Independent Amount: None, Less, Default, or More
- Independent Spacing: Less, Default, or More
- Initial Independent Units Amount: Less, Default, or More

All settings are chosen at game creation and apply for the full game.

## Project Structure

```
advanced-settings-pro.modinfo   Mod manifest: setup criteria and action groups
config/                         Setup screen parameters (shell scope)
data/                           Gameplay adjustments (game scope), grouped by system
l10n/                           Localized text for the 11 non-English languages
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
