// Helpers shared by the mod's map passes.

// Reads a map setup setting and returns the tier it names.
//
// The setup screen stores these settings as plain strings (Hash 0), so the
// chosen value can be read back directly. An unrecognised value falls back to
// the setting's own Standard tier, which is what the base game would have done.
// A setting's Random value, when given, draws one of the table's tiers from the
// map seed, so the same seed always rolls the same tier.
export function zgSettingTier(table, key, standard, random) {
	const value = Configuration.getGameValue(key);
	if (random && value == random) {
		const names = Object.keys(table);
		const name = names[TerrainBuilder.getRandomNumber(names.length, `ZG ${key}`)];
		console.log(`ZG-ASP ${key}: Random rolled ${name}`);
		return table[name];
	}
	return table[value] ?? table[standard];
}

// Visits every tile, row by row from the south, as the base passes do.
export function zgForEachTile(iWidth, iHeight, visit) {
	for (let iY = 0; iY < iHeight; iY++) {
		for (let iX = 0; iX < iWidth; iX++) {
			visit(iX, iY);
		}
	}
}

// Linear interpolation from [from, to] onto [atFrom, atTo], clamped at both ends.
export function zgInterpolate(value, from, to, atFrom, atTo) {
	const t = Math.min(1, Math.max(0, (value - from) / (to - from)));
	return atFrom + (atTo - atFrom) * t;
}
