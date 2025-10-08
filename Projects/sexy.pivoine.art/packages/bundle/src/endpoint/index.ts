const createPolicyFilter = (policy) => ({
	_or: [
		{
			policies: {
				policy: {
					name: {
						_eq: policy,
					},
				},
			},
		},
		{
			role: {
				name: {
					_eq: policy,
				},
			},
		},
	],
});

export default {
	id: "sexy",
	handler: (router, context) => {
		const { services, getSchema } = context;
		const { ItemsService } = services;

		router.get("/stats", async (_req, res) => {
			const usersService = new ItemsService("directus_users", {
				schema: await getSchema(),
			});
			const modelsCount = await usersService.readByQuery({
				aggregate: {
					count: ["*"],
				},
				filter: createPolicyFilter("Model"),
			});
			const viewersCount = await usersService.readByQuery({
				aggregate: {
					count: ["*"],
				},
				filter: createPolicyFilter("Viewer"),
			});

			const videosService = new ItemsService("sexy_videos", {
				schema: await getSchema(),
			});
			const videosCount = await videosService.readByQuery({
				aggregate: {
					count: ["*"],
				},
			});

			res.json({
				models_count: modelsCount[0].count,
				viewers_count: viewersCount[0].count,
				videos_count: videosCount[0].count,
			});
		});
	},
};
