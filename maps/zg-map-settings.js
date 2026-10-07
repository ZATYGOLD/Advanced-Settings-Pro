// Reads a map setup setting and returns the tier it names.
//
// The setup screen stores these settings as plain strings (Hash 0), so the
// chosen value can be read back directly. An unrecognised value falls back to
// the setting's own Standard tier, which is what the base game would have done.
export function zgSettingTier(table, key, standard) {
	return table[Configuration.getGameValue(key)] ?? table[standard];
}
