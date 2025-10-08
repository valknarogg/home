import * as sitemap from "super-sitemap";
import { getArticles, getModels, getVideos } from "$lib/services";

export const GET = async () => {
	return await sitemap.response({
		origin: "https://sexy.pivoine.art",
		excludeRoutePatterns: [
			"^/signup/verify",
			"^/password/reset",
			"^/me",
			"^/play",
			"^/tags/.+",
		],
		paramValues: {
			"/magazine/[slug]": (await getArticles(fetch)).map((a) => a.slug),
			"/models/[slug]": (await getModels(fetch)).map((a) => a.slug),
			"/videos/[slug]": (await getVideos(fetch)).map((a) => a.slug),
		},
		defaultChangefreq: "always",
		defaultPriority: 0.7,
		sort: "alpha", // default is false; 'alpha' sorts all paths alphabetically.
	});
};
