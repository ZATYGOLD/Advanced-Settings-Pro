# Zatygold's Advanced Settings

A Sid Meier's Civilization VII mod that expands game setup for single player and multiplayer. It adds extra options to the Advanced Settings menu, letting you fine-tune systems that normally are not adjustable.

## Version History

### 0.9.04

- New Trade Range (General tab, Trade Settings): -50% to +100% on land and sea trade range, for all ages or per age
- New Trade Speed (Pace tab): Merchants travel Slow, Standard, Quick, or Fast, or trade routes start Instantly, for all ages or per age; Modern can now be made to travel
- Raze Time is renamed Raze Speed and moves to the Pace tab with a row per age (Shorter is now Fast); Roads is renamed Road Speed
- Pace Sets now set Trade Speed and Raze Speed: Swift makes both Instant, Extended slows Trade Speed, the rest keep Standard
- Pace Settings list the cost settings first, then the speed settings
- Fixed remembered settings being lost after closing the game, playing multiplayer, loading a save, or backing out of setup
- Fixed AI Civ Selection, Age Transition: Historical, and Age Transition AI Mementos, having no effect: since patch 1.5 the age transition choice is made in game, and the AI is now settled there, when you confirm your choices. Historical is experimental: the game may still override the AI's civilization
- AI Civ Selection, Age Transition: Historical now keeps each AI to its leader's history: it moves to a Historical civilization when the new age offers one, keeps its civilization when that is the Historical one, and otherwise follows the game's usual path (Confucius: Han, Ming, Qing)
- Player tab: with Zatygold's Spectator, the Spectator's Team shows locked as Spectator and its memento slots are hidden
- Fixed Civic Cost missing the Modern ideology civics, Victory Project Cost scaling nuclear weapons, and leftover pre-1.5 calls in the classic map scripts
- Project reorganized to mirror the base game's layout (ui/shell, ui-next/screens); translations load per locale

### 0.9.03

- Single player remembers this mod's settings between games; Reset to Defaults clears them
- New Raze Time setting: Instant, Shorter, or Standard
- Fixed Advanced Settings not refreshing when a setting adds others (such as map script settings), including with Scrum Lord's Advanced Options Menu Tweaks
- Multiplayer: map script settings now appear on the Map tab

### 0.9.02

- Compatible with WorldStage: the conflict guard no longer blocks Huge Earth Player Expansion

### 0.9.01

- New Building Cost on the Pace tab: the same steps as Technology Cost, covering every building (unique buildings included, wonders excluded); Swift -25%, Balanced +25% / Standard / Standard, Extended +25% / +50% / +50%, and part of every Pace Set
- City Growth is renamed Settlement Growth, and Age Progress Rate is renamed Age Progression

### 0.9.0

- Multiplayer Create Game uses the single-player layout: General, Pace, Map, and Add-Ons tabs, with Random seed buttons
- Multiplayer lobby: memento slots on every row, opening the single-player memento picker; richer leader, civilization, and memento tooltips; View All Rules and Game Options show this mod's settings
- Single player: the Mementos toggle works, Memento Settings moves above Triumph Settings, and Player tab slots return to the Player tab
- Conflict guard recognizes Multiplayer UI Fix
- Fixed AI Mementos choosing mementos for human players
- Fixed setup sync rules on the multiplayer Create Game screen, and multiplayer-only settings appearing in single player

### 0.8.9

- Player tab: memento dropdowns replaced by memento slots for every player, human and AI; clicking one opens the game's memento picker (search bar, attribute filter) for that player and returns to the Player tab
- New Memento Settings group: Mementos, AI Mementos (None, Random, Leader Match, Civilization Match), and Age Transition AI Mementos (Maintain keeps each AI's mementos through an age change; Adapt re-draws them by the AI Mementos rule against the AI's new leader and civilization)
- AI Civ Selection, Age Transition gains a Historical option: each AI follows its leader's civilization-picker associations, Historical by Bias then Geographic, never Strategic; taken civilizations are passed over, ties go to the age's own civilization, and an AI whose pick is the civilization it holds persists
- Conflict guard: eleven more mods recognized, entries grouped by setting, and validation checks every footprint
- Retired the Marathon 2.0 game speed the way Online 2.0 was in 0.8.8: gone from the Game Speed list, still defined so a save running on it keeps working; the Age Length point lists lose its column

### 0.8.8

- New Map Age setting: Old, Standard, or New, trading rough ground against flat; mountains stay with the Mountains setting so the two never move the same tiles
- Resource Density, Resource Clustering, and Guaranteed Resources become one Resources setting: Sparse (25% fewer, in patches of up to three tiles, two of each empire resource per landmass), Standard, or Abundant (25% more, spread evenly, four per landmass)
- Map Settings now runs Map, Map Size, Map Age, Map Temperature, Natural Wonders, Resources, and Map Seed; the Resource Settings group is retired
- Map Temperature's Cold and Hot now move the desert and tundra bands rather than the tropical one, and the list reads Hot, Standard, Cold
- Options with an exact multiplier now state it as a percentage, so each setting's tiers read on one scale; those driven by thresholds or degree shifts keep their plain-language descriptions
- The Rivers options that promise far more navigable water now deliver more of it: the navigable share rises from 45% to 65%, a river needs only one feeder stream to qualify instead of two, and a promoted river must run three tiles rather than two, so the water that is navigable runs in longer stretches. Wadis, Shallow, and Streams tighten the same gate the other way
- Fixed Mountains set to More doing nothing on the Voronoi maps: the pass ran before any rough ground existed, so it had no tiles to raise into peaks
- Fixed the Resources guarantee applying to every resource rather than the ten the game singles out, which put at least two of everything on every landmass; resources the game does not guarantee are left alone
- Fixed the map settings doing nothing at all on Archipelago, Shuffle, and Terra Incognita in their Voronoi form: a patch added those three maps and the mod never claimed them, so they ran the base script and no setting applied, with nothing in the log to say so. Coverage is now 14 maps, checked against the installed game rather than a fixed list
- Retired the Online 2.0 game speed: it no longer appears in the Game Speed list, but stays defined so a game already running on it keeps working. The config row names its own domain, which the Game Speed parameter does not read, rather than being deleted outright. The Age Length point tables lose its column
- Fixed Balanced Age Length never applying its per-age totals: rounding the preset to 150/170/200 left the criteria still asking for the old 153/166/196, so their data files never loaded
- Fixed the conflict guard locking players out of New Game and Continue: the resource-density footprint matched on a `BmdResource` prefix, catching Densmora's Composite Resources Pack, and an unattributed match now only writes to the log

### 0.8.7

- The Map tab gains two groups below Map Settings: Terrain Settings holds Lakes, Rivers, Mountains, and the game's own Sea Level; Resource Settings holds the new resource settings
- New Resource Density, Resource Clustering, and Guaranteed Resources settings
- Resource placement runs through the mod's own copy on all eleven maps, so no base file is replaced

### 0.8.6

- Fixed Fast Treasure Convoy Movement loading outside the Exploration age, where the treasure fleet ability it attaches to does not exist
- Refiled 67 criteria and 68 action groups that had been appended to the end of the manifest instead of placed with their own setting; both lists now run in one section order, sorted by setting, age, then tier
- Medium Military and Civilian Unit Cost now load at the same order as the other unit cost tiers

### 0.8.5

- Player tab gains a Team column, setting the same per-player team the multiplayer lobby does and by the same route, shown as the lobby's own team badge: Leader, Team, Civilization, Mementos
- Teams offer no team plus eight numbered teams, matching the lobby; players on a team win together, since victory is scored per team
- Player tab columns resized to 33.8% Leader, 11.5% Team, 33.8% Civilization, 10.5% each Memento; tighter gap before the Leader column, and long names truncate instead of running under the dropdown arrow
- Memento slots show the icon alone under one Mementos heading, with an empty slot marked by a crossed-out circle; hovering still gives the full memento
- New AI Mementos setting in Game Settings fills every AI player's slots at once: None, Random, Leader Match, or Civilization Match
- A Match draws each slot from one of the leader's or civilization's two attributes, the first slot from the first attribute; it applies only to players whose leader or civilization has been chosen, since AI slots stay on Random until the game starts
- Random Mementos now uses each language's own word for a memento, matching the Mementos column
- Player tab stands aside for mods that provide their own, leaving that tab to them while keeping the Pace and Map tabs; an interim measure until those mods handle the overlap themselves

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

All settings are chosen at game creation and apply for the full game. Single player and multiplayer share the General, Pace, and Map tabs; the Player tab is single player.

### General tab

- Game Settings: Pace Set (mirrors the Pace tab), Single Player No Age Transitions, and a Random button beside Game Random Seed
- Triumph Settings: the game's Triumph Set plus Custom, with an Antiquity, Exploration, and Modern row
- Crisis Settings: Crises (Enabled or Disabled), Crisis Timing (Early, Standard, or Late), and the game's per-crisis selection, kept in step
- Memento Settings: the game's Mementos toggle, AI Mementos (None, Random, Leader Match, or Civilization Match), and Age Transition AI Mementos (Maintain or Adapt)
- Settlement Settings: Settlement Distance (Less, Standard, or More), and Settlement Limit (Less, Standard, More, or Custom, with per-age limits of 1 to 25, then 30 to 75)
- Independent Power Settings: the game's Initial Independent Hostility, Independent Amount (None, Less, Standard, or More), Independent Spacing (Less, Standard, or More), and Independent Aggression (Calm, Standard, or Raging)
- Unit Settings: Settler Movement and Treasure Convoy Movement (Slow, Standard, Quick, or Fast), and Military and Civilian Unit Cost (Low, Standard, Medium, High, or Double)
- Trade Settings: Trade Range (-50% to +100% on land and sea trade range, for all ages or per age)
- Civilization Selection: adds Historical to AI Civ Selection, Age Transition. Each AI moves to its leader's Historical civilization when the new age offers one, keeps its civilization when that is the Historical one, and otherwise follows the game's usual path, a Geographic civilization first (experimental: since patch 1.5 the game may override it)

### Pace tab

Each Pace setting has Antiquity, Exploration, and Modern rows, used when it is Custom. Pace Set presets fill every one of them.

- Age Length: Swift, Abbreviated, Standard, Balanced, Long, Extended, or Custom (per-age totals of 90 to 300)
- Age Progression: Slow, Standard, Balanced, Fast, or Custom
- Technology, Civic, Building, and Victory Project Cost: Low, Standard, Medium, High, Double, Swift, Balanced, Extended, or Custom
- Settlement Growth and Road Speed: Slow, Standard, Quick, Fast, Swift, Balanced, Extended, or Custom
- Trade Speed: Merchants travel Slow, Standard, Quick, or Fast, or trade routes start Instantly; Standard keeps the Modern Age instant
- Raze Speed: Standard, Fast (twice the districts per turn), or Instant

### Map tab

- Map Settings: the game's Map, Map Size, and Map Seed (with a Random button), plus Map Age (Old, Standard, or New), Map Temperature (Hot, Standard, or Cold), Natural Wonders (Disabled to Double), and Resources (Sparse, Standard, or Abundant)
- Terrain Settings: Lakes, Rivers (nine pairings of river count and navigable share), Mountains, and the game's Sea Level
- Natural Wonder Selection: each of the 22 natural wonders, DLC included
- Disaster Settings: Disaster Frequency (Disabled, Light, Moderate, Catastrophic, or Custom per age)

### Player tab (single player)

Leader, Team, Civilization, and two Memento slots on every row; a slot opens the game's memento picker for that player. With Zatygold's Spectator, the Spectator's team shows locked and its memento slots are hidden.

### Multiplayer lobby

Memento slots on every row, fuller leader, civilization, and memento tooltips, and this mod's settings in View All Rules and Game Options.

The conflict guard recognizes conflicting mods by their id and by the setup settings they add, so renaming a mod does not bypass it.

## Project Structure

```
advanced-settings-pro.modinfo   Mod manifest: setup criteria and action groups
config/                         Setup parameters and map script redirects (shell scope)
data/                           Gameplay adjustments (game scope), grouped by system
l10n/                           Text for the 11 non-English languages
maps/                           Map script copies and the zg-map-* generation modules
text/en_us/                     English text
ui/age-transition/              Age transition: AI civilizations and mementos, in game and shell
ui/shell/                       Shell scripts: shared helpers, setup rules and memory,
                                multiplayer create game and lobby
ui-next/screens/create-game/    Advanced Settings tabs, Player tab, memento picker
```

## Requirements

Base game with the Antiquity, Exploration, and Modern age modules.

## Languages

English, German, Spanish, French, Italian, Japanese, Korean, Polish, Brazilian Portuguese, Russian, Simplified Chinese, and Traditional Chinese.

English text lives in text/en_us; the other languages are under l10n, loaded per locale as the game's own modules do.

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.
