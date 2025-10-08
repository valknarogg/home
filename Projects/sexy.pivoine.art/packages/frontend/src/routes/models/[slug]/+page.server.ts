import { error } from "@sveltejs/kit";
import {
	countCommentsForModel,
	getModelBySlug,
	getVideosForModel,
} from "$lib/services.js";
export async function load({ fetch, params }) {
	try {
		const model = await getModelBySlug(params.slug, fetch);
		const commentsCount = await countCommentsForModel(model.id, fetch);
		const videos = await getVideosForModel(model.id, fetch);
		return { model, commentsCount, videos };
	} catch (e) {
		console.log(e);
		error(404, "Model not found");
	}
}
