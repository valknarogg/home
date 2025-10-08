import { error } from "@sveltejs/kit";

export async function load({ locals, url }) {
	const token = url.searchParams.get("token");
	if (!token) {
		error(404, "Not found");
	}
	return {
		authStatus: locals.authStatus,
		token,
	};
}
