// Reads a map setup setting and returns the tier it names.
//
// A setting left on Random draws one of the real tiers here, while the map is
// being generated, rather than being resolved in the setup screen. Two things
// follow from that: the dropdown keeps saying Random, so the result is unknown
// until the map exists, and the draw comes from the map seed through
// TerrainBuilder, so the same seed always yields the same map. Re-rolling the
// seed re-rolls the setting with it.
//
// Every tier table holds only real tiers; the Random value is passed separately
// and never appears in the table.

// The setup screen stores these settings as plain strings (Hash 0), so the
// chosen value can be read back directly.
export function zgSettingTier(table, key, standard, random) {
	const value = Configuration.getGameValue(key);
	if (random && value == random) {
		const tiers = Object.keys(table);
		const drawn = tiers[TerrainBuilder.getRandomNumber(tiers.length, `ZG Random ${key}`)];
		console.log(`ZG-ASP ${key}: Random drew '${drawn}'`);
		return table[drawn];
	}
	return table[value] ?? table[standard];
}
