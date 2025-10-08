import { getArticles } from "$lib/services";
export async function load({ fetch }) {
	return {
		articles: await getArticles(fetch),
	};
}
