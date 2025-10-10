import { error } from "@sveltejs/kit";
import { getArticleBySlug } from "$lib/services.js";
export async function load({ fetch, params, locals }) {
	try {
		return {
			article: await getArticleBySlug(params.slug, fetch),
			authStatus: locals.authStatus,
		};
	} catch {
		error(404, "Article not found");
	}
}
