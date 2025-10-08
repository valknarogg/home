import { error } from "@sveltejs/kit";
import { getItemsByTag } from "$lib/services";

const getItems = (category, tag: string, fetch) => {
	return getItemsByTag(category, fetch).then((items) =>
		items
			?.filter((i) => i.tags.includes(tag))
			.map((i) => ({ ...i, category, title: i["artist_name"] || i["title"] })),
	);
};

export async function load({ fetch, params }) {
	try {
		return {
			tag: params.tag,
			items: await Promise.all([
				getItems("model", params.tag, fetch),
				getItems("video", params.tag, fetch),
				getItems("article", params.tag, fetch),
			]).then(([a, b, c]) => [...a, ...b, ...c]),
		};
	} catch {
		error(404, "Item not found");
	}
}
