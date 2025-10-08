import { error } from "@sveltejs/kit";
import { getCommentsForVideo, getVideoBySlug } from "$lib/services.js";
export async function load({ fetch, params, locals }) {
	const video = await getVideoBySlug(params.slug, fetch);
	const comments = await getCommentsForVideo(video.id, fetch);
	try {
		return { video, comments, authStatus: locals.authStatus };
	} catch {
		error(404, "Video not found");
	}
}
