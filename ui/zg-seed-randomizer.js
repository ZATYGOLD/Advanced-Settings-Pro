// Adds a Random button beside the Game Random Seed and Map Random Seed fields
// of the single-player Advanced Settings screen.
//
// The screen renders every integer setting through the registered TextInput
// component without naming the parameter, so the seed fields are recognised
// by their current value matching one of the seed parameters when the field
// is created. The button feeds a new seed through the field's own setValue.
import { createComponent, mergeProps } from 'fs://game/core/vendor/solid-js/dist/solid.js';
import { insert } from 'fs://game/core/vendor/solid-js/web/dist/web.js';
import { ComponentRegistry } from 'fs://game/core/ui-next/services/component-registry.js';
import { Button } from 'fs://game/core/ui-next/components/button.js';
import { L10n } from 'fs://game/core/ui-next/components/l10n.js';
import 'fs://game/core/ui-next/components/text-input.js';

const OVERRIDE_PRIORITY = 100;
const SEED_PARAM_IDS = ["GameRandomSeed", "MapRandomSeed"];
const MAX_SEED = 2 ** 31 - 1;
const BUTTON_TEXT = "LOC_ADVANCED_OPTIONS_RANDOM";

function seedValues() {
	return SEED_PARAM_IDS
		.map((id) => GameSetup.findGameParameter(id)?.value?.value)
		.filter((value) => value != null)
		.map(String);
}

function isSeedField(props) {
	return typeof props.value == "function" && typeof props.setValue == "function"
		&& props.enableVirtualKeyboard === true && seedValues().includes(String(props.value()));
}

function randomSeed() {
	return String(1 + Math.floor(Math.random() * (MAX_SEED - 1)));
}

const textInput = ComponentRegistry.get("TextInput");
const createBaseTextInput = textInput?.factory;
if (createBaseTextInput) {
	ComponentRegistry.register({
		name: "TextInput",
		overridePriority: OVERRIDE_PRIORITY,
		createInstance: (props) => {
			if (!isSeedField(props)) {
				return createBaseTextInput(props);
			}
			const row = document.createElement("div");
			row.className = "flex flex-row items-center";
			insert(row, createBaseTextInput(mergeProps(props, { class: "w-56 m-1" })));
			insert(row, createComponent(Button, {
				class: "m-1",
				size: "small",
				onActivate: () => props.setValue(randomSeed()),
				children: createComponent(L10n.Compose, { text: BUTTON_TEXT }),
			}));
			return row;
		},
	});
}
