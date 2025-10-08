import { getVideos } from "$lib/services";
export async function load({ fetch }) {
	return {
		videos: await getVideos(fetch),
	};
}
