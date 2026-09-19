# Zatygold's Advanced Settings Pro

A Sid Meier's Civilization VII mod that expands game setup for single player and multiplayer. It adds extra options to the Advanced Settings menu, letting you fine-tune systems that normally are not adjustable.

## Version History

### 0.8.5

- Player tab gains a Team column, setting the same per-player team the multiplayer lobby does and by the same route, shown as the lobby's own team badge: Leader, Team, Civilization, Mementos
- Teams offer no team plus eight numbered teams, matching the lobby; players on a team win together, since victory is scored per team
- Player tab columns resized to 33.8% Leader, 11.5% Team, 33.8% Civilization, 10.5% each Memento; tighter gap before the Leader column, and long names truncate instead of running under the dropdown arrow
- Memento slots show the icon alone under one Mementos heading, with an empty slot marked by a crossed-out circle; hovering still gives the full memento
- New AI Mementos setting in Game Settings fills every AI player's slots at once: None, Random, Leader Match, or Civilization Match
- A Match draws each slot from one of the leader's or civilization's two attributes, the first slot from the first attribute; it applies only to players whose leader or civilization has been chosen, since AI slots stay on Random until the game starts
- Random Mementos now uses each language's own word for a memento, matching the Mementos column

### 0.8.4

- Cost settings run Low (-25%), Standard, Medium (+25%), High (+50%), Double (+100%); Technology, Civic, and Victory Project Cost share one per-age scale
- Settler Movement and Treasure Convoy Movement run Slow, Standard, Quick, Fast
- City Growth and Roads run Slow, Standard, Quick, Fast on quarter steps; Roads loses Express
- Age Length, Technology Cost, Civic Cost, City Growth, Roads, and Victory Project Cost each gain Swift, Balanced, and Extended
- Two new Pace Sets, Swift Pace and Extended Pace; Balanced Pace now sets every pacing setting to Balanced
- Balanced: Age Length 150/170/200, Technology +25%/Standard/-25%, Civic Standard/+25%/+25%, City Growth -25%/-25%/Standard, Roads Standard/Standard/-25%, Victory Project Standard/-25%/-25%
- Swift: Age Length 90/100/110, Technology and Civic -25%/-25%/Standard, City Growth and Victory Project -25% throughout, Roads -25%/-50%/-50%
- Extended: Age Length 240/260/280, Technology and Civic +25%/+50%/+50%, City Growth and Victory Project +25% throughout, Roads Standard/Standard/-25%
- Multiplayer Pace: Age Length 140/160/180, Technology +25%/+50%/+100%, Civic +50%/+50%/+100%, Victory Project Standard/Standard/+25%
- Age Length drops Brief and Doubled; every per-age value is a round ten
- Rewrote every option description in all 12 languages: no option repeats its own name, figures are exact, and anything with more to say reads as a summary with labelled bullets per age, map size, or project
- Age Progress Rate explains what its points do, and all four options give their figures
- Pace Set descriptions list what each one puts on every age
- Random AI mementos re-roll when a new setup screen opens
- Fixed Slow Age Progress Rate giving Modern a third milestone the base game disables

### 0.8.3

- Mountains now applies to the four Voronoi maps as well, so the setting covers all eleven map types; ranges are eroded from their edges or grown outward so they stay contiguous
- Rivers now covers navigable water as well, replacing Less, Standard, and More with nine options that pair three river counts with three navigable shares: Wadis, Arid, Channels, Shallow, Standard, Waterways, Streams, Riverlands, and Deep
- Removed unused imports across the map scripts and replaced a built SQL string in the conflict guard with a static query, matching the base game's own practice

### 0.8.2

- Updated for the latest game patch, which consolidated the Voronoi maps' terrain generation into a single shared routine
- Rebuilt the four Voronoi map scripts (Continents and Islands, Pangaea, Fractal, Shattered Seas) on the new generation pipeline, so the Rivers and Biome settings keep applying on those maps
- Fixed a black screen when opening leader selection: the patch changed the component registry so a registered component's `factory` is an accessor returning the current factory rather than the factory itself, which made the Player, Map and seed field overrides hand the interface a bare function
- Setup screen overrides now tolerate being created without properties, so a future change of this kind cannot blank the screen
- Fixed the per-age Age Length rows defaulting to a value outside their own list, which could leave them blank on the Pace tab

### 0.8.1

- New Pace tab: Age Length, Age Progress Rate, Technology Cost, Civic Cost, City Growth, Roads, and Victory Project Cost, each with Antiquity, Exploration, and Modern rows
- New Pace Set (Game Settings, mirrored on the Pace tab): Standard Pace, Balanced Pace, Multiplayer Pace, or Custom Pace
- Age Length moved to the Pace tab, with Brief, Doubled, and Custom; per-age rows pick an exact point total
- Victory Project Cost now covers every age's science and military triumph projects
- New Map Temperature setting (Cold, Standard, Hot) after Map Size; Natural Wonders now sits in Map Settings
- Renamed cost options to Low, Standard, High, and Double; Default is now Standard everywhere

### 0.8.0

- New Map tab holding the map, natural wonder, and disaster settings
- Added Nachi Falls and Seongsan Ilchulbong to Natural Wonder Selection (22 wonders)
- Crisis Settings group with a Crises on/off switch and Crisis Timing (Early, Standard, Late)
- Disaster Frequency and Triumph Set gain Custom with per-age choices
- AI Mementos on the Player tab, with None and Random
- Random buttons for the Game and Map seeds
- Custom settlement limits run 1 to 25, then 30 to 75 in steps of 5
- Unit costs: Low, Standard, High, or Double
- Lakes, Rivers, and Mountains drop Disabled; Raging independents are stronger (x3 boldness, 3/5/7 starting units)
- Initial Independent Hostility moved to Independent Power Settings
- Cleaner tooltips, a stronger conflict guard (recognizes conflicting mods by their settings), and a fix for multiplayer settings showing in single player

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
- Age Length: the game's own setting, moved to Pace Settings on the Pace tab and extended with Brief (90), Doubled (280), and Custom; it drives the per-age rows (any total from 90 to 300), and a per-age change shows Custom; switching it off Custom returns every other Pace Settings setting to Standard
- Pace Set (Game Settings, mirrored on the Pace tab): Swift Pace, Standard Pace, Balanced Pace, Extended Pace, Multiplayer Pace, or Custom Pace (written into the Pace Settings on the Pace tab)
- Age Progress Rate: Slow, Standard, Balanced, Fast, or Custom (milestone and future tech/civic points x0.5 / x1 / the Balanced curve / x1.5)
- Technology Cost and Civic Cost: Low (25% cheaper), Standard, Medium (25% more), High (50% more), Double (100% more), or Custom (per-age rows pick -25%, +25%, +35% to +100%)
- City Growth: Slow (25% more Food per citizen), Standard, Quick (25% less), Fast (half), or Custom
- Roads: Slow (25% more movement cost), Standard, Quick (25% less), Fast (50% less), or Custom
- Victory Project Cost: Low, Standard, Medium, High, Double, or Custom (per-age rows pick -25%, +20%, +25%, +50%, or +100%); covers every age's science and military triumph projects, from Chart the Stars to Launch Rocket and Operation Ivy
- Antiquity, Exploration, and Modern rows for each Custom pacing setting above
- Disaster Frequency: Disabled, Light, Moderate, Catastrophic, or Custom
- Antiquity, Exploration, and Modern disaster frequency: Disabled, Light, Moderate, or Catastrophic each, applied when Disaster Frequency is set to Custom
- Settler Speed: Slow, Standard, Quick, or Fast
- Treasure Convoy Speed: Slow, Standard, Quick, or Fast
- Military Unit Cost: Low (25% cheaper), Standard, Medium (25% more), High (50% more), or Double (100% more)
- Civilian Unit Cost: Low (25% cheaper), Standard, Medium (25% more), High (50% more), or Double (100% more)
- Natural Wonders: Disabled, Half, Standard, More, or Double
- Natural Wonder Selection: Enabled or Disabled for each of the 22 natural wonders, including DLC wonders
- Map Temperature: Cold, Standard, or Hot (Hot extends the tropical band 8 degrees and the desert band 7 degrees toward the poles; Cold starts tundra 8 degrees closer to the equator; plains and grassland only shrink where those bands grow)
- Lakes: Less, Standard, or More
- Rivers: sets both how many rivers are generated and what share of them are Navigable Rivers rather than Minor Rivers, as every pairing of three river counts with three navigable shares. The list is grouped by river count, fewest first. Few rivers: Wadis, Arid, or Channels. A standard number: Shallow, Standard, or Waterways. Many rivers: Streams, Riverlands, or Deep. Within each group the first has far fewer of those rivers navigable, the second keeps the game's own share, and the third has far more; Standard leaves generation entirely untouched
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

The conflict guard recognizes conflicting mods by their id and by the setup settings they add to the game, so renaming a mod does not bypass it.

All settings are chosen at game creation and apply for the full game.

In single player, the Advanced Settings screen gains a Pace tab (Pace Settings plus a group per age) and a Map tab between General and Player; the Map tab holds the map, natural wonder, and disaster settings, while the crisis settings move into their own Crisis Settings group on General and Initial Independent Hostility joins the Independent Power settings; multiplayer keeps the game's standard layout.

## Project Structure

```
advanced-settings-pro.modinfo   Mod manifest: setup criteria and action groups
config/                         Setup screen parameters (shell scope)
data/                           Gameplay adjustments (game scope), grouped by system
l10n/                           Localized text for the 11 non-English languages
maps/                           Map script copies that apply the map generation settings
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
