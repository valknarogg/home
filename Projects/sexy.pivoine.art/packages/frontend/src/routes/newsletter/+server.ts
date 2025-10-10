import {
	LETTERSPACE_API_KEY,
	LETTERSPACE_API_URL,
	LETTERSPACE_LIST_ID,
} from "$env/static/private";
import { json } from "@sveltejs/kit";

export async function POST({ request, fetch }) {
	const { email } = await request.json();
	const lists = [LETTERSPACE_LIST_ID];

	await fetch(`${LETTERSPACE_API_URL}/subscribers`, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
			"X-API-Key": LETTERSPACE_API_KEY,
		},
		body: JSON.stringify({ email, lists }),
	});

	return json({ email }, { status: 201 });
}
