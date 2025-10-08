import { error } from "@sveltejs/kit";
import { verify } from "$lib/services.js";
export async function load({ fetch, url }) {
	const token = url.searchParams.get("token");
	try {
		if (!token) {
			throw new Error();
		}
		await verify(token, fetch).catch((err) => {
			if (err.response.status != 302) {
				throw err;
			}
		});
		// redirect(308, '/login');
	} catch {
		error(404, "Not found");
	}
}
