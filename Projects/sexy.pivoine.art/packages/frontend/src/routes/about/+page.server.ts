import { getStats } from "$lib/services";
export async function load({ fetch }) {
	return {
		stats: await getStats(fetch),
	};
}
