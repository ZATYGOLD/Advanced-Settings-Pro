# Zatygold's Advanced Settings Pro

A Sid Meier's Civilization VII mod that expands game setup for single player and multiplayer. It adds extra options to the Advanced Settings menu, letting you fine-tune systems that normally are not adjustable.

## Version History

### 0.8.4

- Every cost setting gains a Medium step between Standard and High, so the scale runs Low (-25%), Standard, Medium (+25%), High (+50%), Double (+100%); the per-age rows gain a matching +25%
- Settler Movement and Treasure Convoy Movement run Slow, Standard, Quick, Fast, with Quick matching the old Fast and Fast adding a further movement point
- City Growth and Roads run Slow, Standard, Quick, Fast on matching quarter steps: Slow costs 25% more, Quick 25% less, Fast half. City Growth scales every term of the Food threshold together, so the percentages hold exactly at any city size
- Roads loses Express, and Multiplayer Pace now uses Quick for Antiquity and Exploration and Fast for Modern
- Rewrote the descriptions for every cost and speed setting. Each option now states an exact figure: Roads gives the movement cost per tile, City Growth the Food multiplier, Settler and Treasure their movement points, and every cost tier is anchored to a worked example (a Warrior at 30 Production, Pottery at 70 Science, and so on). Each setting's own tooltip explains what it controls
- Technology, Civic and Victory Project cost now have their own option descriptions rather than sharing one generic set. Victory Project lists all 12 triumph projects with their adjusted cost, and every figure that scales with game speed now says it is quoted on Standard Speed
- The per-age City Growth and Roads rows show their percentage as the option name (+25%, Standard, -25%, -50%), matching how the Technology, Civic and Victory Project rows already read
- Age Length, Technology Cost, Civic Cost, City Growth, Roads and Victory Project Cost each gain Swift, Balanced and Extended options, every one expanding to its own per-age shape, so each Pace Set reads as itself across the board instead of Custom
- Balanced: Age Length 153/166/196, Technology +25%/Standard/-25%, Civic Standard/+25%/+25%, City Growth -25%/-25%/Standard, Roads Standard/Standard/-25%, Victory Project Standard/-25%/-25%
- Swift: Age Length 90/100/110, Technology and Civic -25%/-25%/Standard, City Growth and Victory Project -25% throughout, Roads -25%/-50%/-50%
- Extended: Age Length 240/260/280, Technology and Civic +25%/+50%/+50%, City Growth and Victory Project +25% throughout, Roads Standard/Standard/-25%
- Removed the Brief (90) and Doubled (280) Age Lengths, which no preset used; Age Length is now the game's own Abbreviated, Standard and Long plus Swift, Balanced, Extended and Custom
- Random AI mementos are re-rolled when a new setup screen opens instead of keeping the previous game's picks for as long as the app stays open
- Two new Pace Sets, Swift Pace and Extended Pace, each setting every pacing setting to its matching option
- Balanced Pace likewise sets every pacing setting to its own Balanced option
- Reformatted every option description across all 12 languages. No description repeats the option's own name any more, since the dropdown already shows it; a description that says one thing is now a plain sentence rather than a single bullet
- Anything with more than one thing to say reads as a short summary followed by labelled bullets: Swift, Balanced and Extended list their Antiquity, Exploration and Modern values; Natural Wonders lists its count per map size; Victory Project Cost lists all 12 projects under an "Antiquity / Exploration / Modern" header
- Settlement Limit, Independent Space and Crisis Timing were putting the option's name where the Antiquity (or Stage 1) row belonged, so the first figure read as a summary rather than as the age it applies to. Every row now carries its real label
- The per-age bullets and the Pace Set descriptions are generated from the same tables the rules engine applies, so the tooltip cannot drift from the behaviour. That caught the Multiplayer Pace text still describing Roads as Express, an option 0.8.4 removed
- The "(On Standard Speed)" note now appears only where a description quotes a concrete figure. A percentage holds at any speed, so the per-age percentage rows no longer carry it
- 60 rows used to describe themselves: the Technology, Civic and Victory per-age rows are named by their percentage and their tooltip repeated it, all 35 Settlement Limit values echoed their own number, and the Natural Wonder toggle read "Enabled: Enabled". Each now says what it does — "25% more Science in this age", "The most settlements you may hold in this age", "This Natural Wonder can appear on the map"
- Rewrote Age Progress Rate, which never explained what its points were for. The setting now says that Legacy Path milestones and future techs and civics fill the age meter while Age Length sets the total that ends the age, and that the figures are each age's first, second and third milestone. Every option states which way it moves age length — Slow runs ages longer, Fast ends them sooner — and all four now give their exact figures rather than only Balanced
- The per-age Age Progress Rate rows no longer reuse the tier text, which had an Antiquity row listing all three ages' figures. They now describe just the age they control
- Fixed Slow reviving Modern's third milestone. It halves each award with a floor of 1 so small values do not round away, but Modern's third milestone is 0 in the base game and the floor was turning it into 1, awarding age progress the base game never gives
- A note after a bulleted list now has a blank line before it, using the game's own `[nn]` token. `[n][n]` is not a paragraph break — it renders as a single line break, which left the note sitting hard against the last bullet where it read as another list item
- Proofread every description in all 12 languages against one set of rules: a bullet is a label and a value and takes no full stop, while a lead sentence or trailing note is prose and does. The text had been inconsistent, with "Antiquity: 4 Tiles." next to "Antiquity: 3, 3 and 5"
- Eight languages carried two different translations of the Standard Speed note — an older one inline in the cost descriptions and a newer one added later, differing in wording and capitalisation. All 24 uses in each language now read the same and sit in the same place
- French now sets a space before a colon and a semicolon throughout, including the per-age Age Length tables that had been left with English spacing
- English corrections: the serial comma is used in lists of three or more, matching the rest of the mod's writing; Independent Powers is capitalised consistently; "amount" gives way to "number" for things that can be counted; "triumph projects" is now "Victory Projects", the name the setting itself uses; and "tiles" and "points" are lower case, as the base game writes them
- The Settlement Limit rows read "Antiquity: 5 settlements" rather than "Antiquity: 5 settlement limit", which was not a phrase
- The Independent Powers and Lakes descriptions each said the same thing three times over; both are now a sentence and a caveat
- Language fixes carried by that pass: French, Japanese and Chinese descriptions use their own separator and full stop throughout rather than switching to ASCII mid-tooltip; Russian and Polish counts take the right form for one, a few and many; Chinese and Japanese no longer put a space between a figure and its counter

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
