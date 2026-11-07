// Adds a Random button beside the Game Random Seed and Map Random Seed fields
// of the single-player Advanced Settings screen.
//
// The screen renders every integer setting through the registered TextInput
// component without naming the parameter, so the seed fields are recognized
// by their current value matching one of the seed parameters when the field
// is created. The button feeds a new seed through the field's own setValue.
import { createComponent, mergeProps } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { insert } from 'fs://game/core/vendor/solid-js/web/dist/web.js';
import { Button } from 'fs://game/core/ui-next/components/button.js';
import { L10n } from 'fs://game/core/ui-next/components/l10n.js';
import 'fs://game/core/ui-next/components/text-input.js';
import { gameValue, isMultiplayer } from '../../../ui/shared/zg-config.js';
import { SEED_BUTTON_TEXT, SEED_PARAM_IDS, randomSeed } from '../../../ui/shell/shared/zg-setup-tabs.js';
import { zgWrapComponent } from './zg-component-override.js';

const OVERRIDE_PRIORITY = 100;

function seedValues() {
	return SEED_PARAM_IDS
		.map((id) => gameValue(id))
		.filter((value) => value != null)
		.map(String);
}

function isSeedField(props) {
	return !isMultiplayer() && props != null && typeof props.value == "function" && typeof props.setValue == "function"
		&& props.enableVirtualKeyboard === true && seedValues().includes(String(props.value()));
}

zgWrapComponent("TextInput", OVERRIDE_PRIORITY, (createBaseTextInput) => (props) => {
	if (!isSeedField(props)) {
		return createBaseTextInput(props);
	}
	const row = document.createElement("div");
	row.className = "flex flex-row items-center";
	insert(row, createBaseTextInput(mergeProps(props, { class: "w-56 m-1" })));
	insert(row, createComponent(Button, {
		class: "m-1",
		size: "small",
		onActivate: () => props.setValue(String(randomSeed())),
		children: createComponent(L10n.Compose, { text: SEED_BUTTON_TEXT }),
	}));
	return row;
});
