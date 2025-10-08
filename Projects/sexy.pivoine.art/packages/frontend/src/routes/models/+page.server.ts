import { getModels } from "$lib/services";
export async function load({ fetch }) {
	return {
		models: await getModels(fetch),
	};
}
