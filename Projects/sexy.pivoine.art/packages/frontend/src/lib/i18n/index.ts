import { init, addMessages } from "svelte-i18n";
import en from "./locales/en";

const defaultLocale = "en";

addMessages("en", en);

init({
	fallbackLocale: defaultLocale,
	initialLocale: defaultLocale,
});
