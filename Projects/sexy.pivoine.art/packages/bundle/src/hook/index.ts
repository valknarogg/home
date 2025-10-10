import { createRequire } from "module";
global.require = createRequire(import.meta.url);
import { defineHook } from "@directus/extensions-sdk";
import slugify from "@sindresorhus/slugify";
import ffmpeg from "fluent-ffmpeg";

async function processVideo(
	meta,
	{ schema, accountability },
	services,
	logger,
) {
	const { FilesService } = services;
	const itemId = meta.key;
	const videoPath = `/directus/uploads/${meta.payload.filename_disk}`; // Adjust path as needed
	const videoService = new FilesService({ schema, accountability }); // Replace with your collection name

	try {
		const durationInSeconds = await new Promise((resolve, reject) => {
			ffmpeg.ffprobe(videoPath, function (err, metadata) {
				if (err) {
					reject(err);
				}
				resolve(parseInt(metadata.format.duration));
			});
		});
		// Update the item with the duration
		await videoService.updateOne(itemId, { duration: durationInSeconds });
		logger.info(`Video ${itemId} duration updated to ${durationInSeconds}`);
	} catch (error) {
		logger.error(`Error processing video ${itemId}:`, error);
	}
}

export default defineHook(async ({ filter, action }, { services, logger }) => {
	action("files.upload", async (meta, context) => {
		await processVideo(meta, context, services, logger);
	});

	filter(
		"users.create",
		(payload: {
			first_name: string;
			last_name: string;
			artist_name: string;
			slug: string;
		}) => {
			const artist_name = `${payload.first_name}-${new Date().getTime()}`;
			const slug = slugify(artist_name);
			const join_date = new Date();
			return { ...payload, artist_name, slug, join_date };
		},
	);

	filter(
		"users.update",
		(payload: {
			first_name: string;
			last_name: string;
			artist_name: string;
			slug: string;
		}) => {
			if (payload.artist_name) {
				const slug = slugify(payload.artist_name);
				return { ...payload, slug };
			}
			return payload;
		},
	);
});
