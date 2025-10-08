import { isAuthenticated } from "$lib/services";

export async function handle({ event, resolve }) {
	const { cookies, locals } = event;

	const token = cookies.get("directus_session_token");

	if (token) {
		locals.authStatus = await isAuthenticated(token);
		// if (locals.authStatus.authenticated) {
		//     cookies.set('directus_refresh_token', locals.authStatus.data!.refresh_token!, {
		//         httpOnly: true,
		//         secure: true,
		//         domain: '.pivoine.art',
		//         path: '/'
		//     })
		// }
	} else {
		locals.authStatus = { authenticated: false };
	}

	return await resolve(event, {
		filterSerializedResponseHeaders: (key) => {
			return key.toLowerCase() === "content-type";
		},
	});
}
