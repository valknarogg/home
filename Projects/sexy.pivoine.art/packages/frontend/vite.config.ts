import path from "path";
import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";
import { sveltekit } from "@sveltejs/kit/vite";

export default defineConfig({
	plugins: [sveltekit(), tailwindcss()],
	resolve: {
		alias: { $lib: path.resolve("./src/lib"), "@": path.resolve("./src/lib") },
	},
	server: {
		proxy: {
			"/api": {
				rewrite: (path) => path.replace(/^\/api/, ""),
				target: "http://localhost:8055",
				changeOrigin: true,
				secure: false,
				ws: true,
			},
		},
	},
});
