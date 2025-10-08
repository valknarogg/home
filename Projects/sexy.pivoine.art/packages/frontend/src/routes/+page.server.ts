import { getFeaturedModels, getFeaturedVideos } from "$lib/services";
export async function load({ fetch }) {
	return {
		models: await getFeaturedModels(3, fetch),
		videos: await getFeaturedVideos(3, fetch),
	};
}
