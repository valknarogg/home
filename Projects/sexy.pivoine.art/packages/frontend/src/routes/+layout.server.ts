export async function load({ locals }) {
	return {
		authStatus: locals.authStatus,
	};
}
