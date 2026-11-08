// Helpers shared by the mod's map passes.

// Reads a map setup setting and returns the tier it names.
//
// The setup screen stores these settings as plain strings (Hash 0), so the
// chosen value can be read back directly. An unrecognized value falls back to
// the setting's own Standard tier, which is what the base game would have done.
// A setting's Random value, when given, draws one of the table's tiers from the
// map seed, so the same seed always rolls the same tier; `scope` names it in the log.
export function zgSettingTier(table, key, standard, random, scope = key) {
	const value = Configuration.getGameValue(key);
	if (random && value == random) {
		const names = Object.keys(table);
		const name = names[TerrainBuilder.getRandomNumber(names.length, `ZG ${key}`)];
		console.log(`ZG-ASP ${scope}: Random rolled ${name}`);
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

// The tile next to a location in a direction, or null off the map.
export function zgAdjacent(location, direction) {
	const adjacent = GameplayMap.getAdjacentPlotLocation(location, direction);
	return adjacent && adjacent.x >= 0 && adjacent.y >= 0 ? adjacent : null;
}

// Linear interpolation from [from, to] onto [atFrom, atTo], clamped at both ends.
export function zgInterpolate(value, from, to, atFrom, atTo) {
	const t = Math.min(1, Math.max(0, (value - from) / (to - from)));
	return atFrom + (atTo - atFrom) * t;
}
