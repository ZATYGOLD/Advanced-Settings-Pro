# Zatygold's Advanced Settings Pro

A Sid Meier's Civilization VII mod that expands game setup for single player and multiplayer. It adds extra options to the Advanced Settings menu, letting you fine-tune systems that normally are not adjustable.

## Version History

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
- Natural Wonders: None, Half, Default, More, or Double
- Lakes: Less, Default, or More
- Crisis Speed: Crawl, Slow, Default, Quick, or Fast
- Settlement Limit: Less, Default, or More
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
text/en_us/                     English localization
```

## Requirements

Base game with the Antiquity, Exploration, and Modern age modules.

## Languages

- English

All text strings are stored in localization files under the text directory; the structure supports additional languages.

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.
