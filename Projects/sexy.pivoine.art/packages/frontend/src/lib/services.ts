import { getDirectusInstance } from "$lib/directus";
import {
	readItems,
	registerUser,
	updateMe,
	readMe,
	registerUserVerify,
	readUsers,
	passwordRequest,
	passwordReset,
	customEndpoint,
	readFolders,
	deleteFile,
	uploadFiles,
	createComment,
	readComments,
	aggregate,
} from "@directus/sdk";
import type { Article, Model, Stats, User, Video } from "$lib/types";
import { PUBLIC_URL } from "$env/static/public";

const userFields = [
	"*",
	{
		avatar: ["*"],
		policies: ["*", { policy: ["name", "id"] }],
		role: ["*", { policies: [{ policy: ["name", "id"] }] }],
	},
];

export async function isAuthenticated(token: string) {
	try {
		const directus = getDirectusInstance(fetch);
		directus.setToken(token);
		const user = await directus.request(
			readMe({
				fields: userFields,
			}),
		);
		return { authenticated: true, user };
	} catch {
		return { authenticated: false };
	}
}

export async function register(
	email: string,
	password: string,
	firstName: string,
	lastName: string,
) {
	const directus = getDirectusInstance(fetch);
	return directus.request(
		registerUser(email, password, {
			verification_url: `${PUBLIC_URL}/signup/verify`,
			first_name: firstName,
			last_name: lastName,
		}),
	);
}

export async function verify(token: string, fetch?: typeof globalThis.fetch) {
	const directus = fetch
		? getDirectusInstance((args) => fetch(args, { redirect: "manual" }))
		: getDirectusInstance(fetch);
	return directus.request(registerUserVerify(token));
}

export async function login(email: string, password: string) {
	const directus = getDirectusInstance(fetch);
	return directus.login({ email, password });
}

export async function logout() {
	const directus = getDirectusInstance(fetch);
	return directus.logout();
}

export async function requestPassword(email: string) {
	const directus = getDirectusInstance(fetch);
	return directus.request(
		passwordRequest(email, `${PUBLIC_URL}/password/reset`),
	);
}

export async function resetPassword(token: string, password: string) {
	const directus = getDirectusInstance(fetch);
	return directus.request(passwordReset(token, password));
}

export async function getArticles(fetch?: typeof globalThis.fetch) {
	const directus = getDirectusInstance(fetch);
	return directus.request<Article[]>(
		readItems("sexy_articles", {
			fields: ["*", "author.*"],
			where: { publish_date: { _lte: new Date().toISOString() } },
			sort: ["-publish_date"],
		}),
	);
}

export async function getArticleBySlug(
	slug: string,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus
		.request<Article[]>(
			readItems("sexy_articles", {
				fields: ["*", "author.*"],
				filter: { slug: { _eq: slug } },
			}),
		)
		.then((articles) => {
			if (articles.length === 0) {
				throw new Error("Article not found");
			}
			return articles[0];
		});
}

export async function getVideos(fetch?: typeof globalThis.fetch) {
	const directus = getDirectusInstance(fetch);
	return directus
		.request<Video[]>(
			readItems("sexy_videos", {
				fields: [
					"*",
					{
						models: [
							"*",
							{
								directus_users_id: ["*"],
							},
						],
					},
					"movie.*",
				],
				filter: { upload_date: { _lte: new Date().toISOString() } },
				sort: ["-upload_date"],
			}),
		)
		.then((videos) => {
			videos.forEach((video) => {
				video.models = video.models.map((u) => u.directus_users_id!);
			});
			return videos;
		});
}

export async function getVideosForModel(id, fetch?: typeof globalThis.fetch) {
	const directus = getDirectusInstance(fetch);
	return directus.request<Video[]>(
		readItems("sexy_videos", {
			fields: ["*", "movie.*"],
			filter: {
				models: {
					directus_users_id: {
						id,
					},
				},
			},
			sort: ["-upload_date"],
		}),
	);
}

export async function getFeaturedVideos(
	limit: number,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus
		.request<Video[]>(
			readItems("sexy_videos", {
				fields: [
					"*",
					{
						models: [
							"*",
							{
								directus_users_id: ["*"],
							},
						],
					},
					"movie.*",
				],
				filter: {
					upload_date: { _lte: new Date().toISOString() },
					featured: true,
				},
				sort: ["-upload_date"],
				limit,
			}),
		)
		.then((videos) => {
			videos.forEach((video) => {
				video.models = video.models.map((u) => u.directus_users_id!);
			});
			return videos;
		});
}

export async function getVideoBySlug(
	slug: string,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus
		.request<Video[]>(
			readItems("sexy_videos", {
				fields: [
					"*",
					{
						models: [
							"*",
							{
								directus_users_id: ["*"],
							},
						],
					},
					"movie.*",
				],
				filter: { slug },
			}),
		)
		.then((videos) => {
			if (videos.length === 0) {
				throw new Error("Video not found");
			}
			videos[0].models = videos[0].models.map((u) => u.directus_users_id!);

			return videos[0];
		});
}

const modelFilter = {
	_or: [
		{
			policies: {
				policy: {
					name: {
						_eq: "Model",
					},
				},
			},
		},
		{
			role: {
				name: {
					_eq: "Model",
				},
			},
		},
	],
};

export async function getModels(fetch?: typeof globalThis.fetch) {
	const directus = getDirectusInstance(fetch);
	return directus.request<Model[]>(
		readUsers({
			fields: ["*"],
			filter: modelFilter,
			sort: ["-join_date"],
		}),
	);
}

export async function getFeaturedModels(
	limit = 3,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus.request<Model[]>(
		readUsers({
			fields: ["*"],
			filter: { _and: [modelFilter, { featured: { _eq: true } }] },
			sort: ["-join_date"],
			limit,
		}),
	);
}

export async function getModelBySlug(
	slug: string,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus
		.request<Model[]>(
			readUsers({
				fields: [
					"*",
					{
						photos: [
							"*",
							{
								directus_files_id: ["*"],
							},
						],
					},
					"banner.*",
				],
				filter: { _and: [modelFilter, { slug: { _eq: slug } }] },
			}),
		)
		.then((models) => {
			if (models.length === 0) {
				throw new Error("Model not found");
			}
			models[0].photos = models[0].photos.map((p) => p.directus_files_id!);
			return models[0];
		});
}

export async function updateProfile(user: Partial<User>) {
	const directus = getDirectusInstance(fetch);
	return directus.request<User>(updateMe(user as never));
}

export async function getStats(fetch?: typeof globalThis.fetch) {
	const directus = getDirectusInstance(fetch);
	return directus.request<Stats>(
		customEndpoint({
			path: "/sexy/stats",
		}),
	);
}

export async function getFolders(fetch?: typeof globalThis.fetch) {
	const directus = getDirectusInstance(fetch);
	return directus.request(readFolders());
}

export async function removeFile(id: string) {
	const directus = getDirectusInstance(fetch);
	return directus.request(deleteFile(id));
}

export async function uploadFile(data: FormData) {
	const directus = getDirectusInstance(fetch);
	return directus.request(uploadFiles(data));
}

export async function createCommentForVideo(item: string, comment: string) {
	const directus = getDirectusInstance(fetch);
	return directus.request(
		createComment({
			collection: "sexy_videos",
			item,
			comment,
		}),
	);
}

export async function getCommentsForVideo(
	item: string,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus.request(
		readComments({
			fields: ["*", { user_created: ["*"] }],
			filter: { collection: "sexy_videos", item },
			sort: ["-date_created"],
		}),
	);
}

export async function countCommentsForModel(
	user_created: string,
	fetch?: typeof globalThis.fetch,
) {
	const directus = getDirectusInstance(fetch);
	return directus
		.request<[{ count: number }]>(
			aggregate("directus_comments", {
				aggregate: {
					count: "*",
				},
				query: {
					filter: { user_created },
				},
			}),
		)
		.then((result) => result[0].count);
}

export async function getItemsByTag(
	category: "video" | "article" | "model",
	tag: string,
	fetch?: typeof globalThis.fetch,
) {
	switch (category) {
		case "video":
			return getVideos(fetch);
		case "model":
			return getModels(fetch);
		case "article":
			return getArticles(fetch);
	}
}
