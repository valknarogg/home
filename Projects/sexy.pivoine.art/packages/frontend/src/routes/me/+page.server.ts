import { getFolders } from "$lib/services";

export async function load({ locals, fetch }) {
	return {
		authStatus: locals.authStatus,
		folders: await getFolders(fetch),
	};
}
