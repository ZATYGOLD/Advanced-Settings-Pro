// Setup data readers shared by the shell and the game, both of which load them.

// A config database query that logs and yields no rows rather than throwing.
export function queryConfig(sql) {
	try {
		return Database.query("config", sql) ?? [];
	} catch (error) {
		console.error(`ZG-ASP config: query failed: ${error}`);
		return [];
	}
}

// A value built on first use and kept; the config database does not change
// while a scope is loaded.
export function cached(build) {
	let value;
	return () => (value ??= build());
}

// A setup parameter's current value.
export const gameValue = (parameterId) => GameSetup.findGameParameter(parameterId)?.value?.value;
export const playerValue = (playerId, parameterId) => GameSetup.findPlayerParameter(playerId, parameterId)?.value?.value;

// Whether an installed mod is enabled.
export const isModEnabled = (modId) => Modding.getInstalledMods().some((mod) => mod.enabled && mod.id == modId);

// A setup string handle as text, or "" when it does not resolve.
export const resolveName = (handle) => GameSetup.resolveString(handle) ?? "";
