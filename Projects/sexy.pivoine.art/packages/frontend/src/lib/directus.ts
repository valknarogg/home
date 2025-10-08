import { authentication, createDirectus, rest } from "@directus/sdk";
import { PUBLIC_API_URL } from "$env/static/public";
import type { CurrentUser } from "./types";

export const directusApiUrl = PUBLIC_API_URL;

export const getDirectusInstance = (fetch?: typeof globalThis.fetch) => {
	const options: { globals?: { fetch: typeof globalThis.fetch } } = fetch
		? { globals: { fetch } }
		: {};
	const directus = createDirectus(directusApiUrl, options)
		.with(rest())
		.with(authentication("session"));
	return directus;
};

export const getAssetUrl = (
	id: string,
	transform?: "mini" | "thumbnail" | "preview" | "medium" | "banner",
) => {
	if (!id) {
		return null;
	}
	return `${directusApiUrl}/assets/${id}${transform ? "?transform=" + transform : ""}`;
};

export const isModel = (user: CurrentUser) => {
	if (user.role.name === "Model") {
		return true;
	}
	if (user.policies.find((p) => p.policy.name === "Model")) {
		return true;
	}
	return false;
};
