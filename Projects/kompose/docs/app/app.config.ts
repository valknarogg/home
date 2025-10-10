export default defineAppConfig({
	ui: {
		colors: {
			primary: "emerald",
			secondary: "fuchsia",
			neutral: "zinc",
		},
		footer: {
			slots: {
				root: "border-t border-default",
				left: "text-sm text-muted",
			},
		},
	},
	seo: {
		siteName: "Kompose",
	},
	header: {
		title: "",
		to: "/",
		logo: {
			alt: "",
			light: "",
			dark: "",
		},
		search: true,
		colorMode: true,
		links: [
			{
				icon: "i-simple-icons-github",
				to: "https://github.com/nuxt-ui-templates/docs",
				target: "_blank",
				"aria-label": "GitHub",
			},
		],
	},
	footer: {
		credits: `kompose © Valknar ${new Date().getFullYear()}`,
		colorMode: false,
		links: [
			{
				icon: "i-simple-icons-x",
				to: "https://x.com/bordeaux1981",
				target: "_blank",
				"aria-label": "Nuxt on X",
			},
			{
				icon: "i-simple-icons-github",
				to: "https://github.com/valknarogg",
				target: "_blank",
				"aria-label": "Valknar on GitHub",
			},
		],
	},
	toc: {
		title: "Table of Contents",
		bottom: {
			title: "Community",
			edit: "https://code.pivoine.art/valknar/kompose/src/branch/main/docs/content",
			links: [],
		},
	},
});
