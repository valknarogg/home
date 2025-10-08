import { defineTheme } from "@directus/extensions-sdk";
import "./style.css";

export default defineTheme({
	id: "@sexy.pivoine.art/theme",
	name: "Sexy.Art Dark",
	appearance: "dark",
	rules: {
		borderRadius: "6px",
		borderWidth: "2px",
		foreground: "#c9d1d9",
		foregroundSubdued: "#666672",
		foregroundAccent: "#f0f6fc",
		background: "#0D1117",
		backgroundNormal: "#21262E",
		backgroundAccent: "#30363D",
		backgroundSubdued: "#161B22",
		borderColor: "#21262E",
		borderColorAccent: "#30363D",
		borderColorSubdued: "#161B22",
		primary: "#ce47eb",
		secondary: "#613dff",
		success: "#87ff66",
		warning: "#ffbf66",
		danger: "#ff6467",
		navigation: {
			background: "#21262E",
			backgroundAccent: "#30363D",
			borderWidth: "0px",
			borderColor: "transparent",
			project: {
				background: "#30363D",
				borderWidth: "0px",
				borderColor: "transparent",
			},
			modules: {
				borderWidth: "0px",
				borderColor: "transparent",
				button: {
					foregroundHover: "#fff",
					background: "transparent",
					backgroundHover: "transparent",
					backgroundActive: "#21262E",
				},
			},
			list: {
				background: "transparent",
				backgroundHover: "#30363D",
				backgroundActive: "#30363D",
				divider: {
					borderColor: "#30363D",
				},
			},
		},
		header: {
			borderWidth: "0px",
			borderColor: "transparent",
			boxShadow: "0 4px 7px -4px black",
		},
		form: {
			columnGap: "32px",
			rowGap: "40px",
			field: {
				label: {
					fontWeight: "600",
				},
				input: {
					borderColor: "#21262E",
					borderColorHover: "#30363D",
					boxShadow: "none",
					boxShadowHover: "none",
					height: "60px",
					padding: "16px",
				},
			},
		},
		sidebar: {
			background: "#21262E",
			borderWidth: "0px",
			borderColor: "transparent",
			section: {
				toggle: {
					background: "#30363D",
					borderWidth: "0px",
					borderColor: "transparent",
				},
				form: {
					field: {
						input: {
							height: "52px",
							padding: "12px",
						},
					},
				},
			},
		},
		public: {
			art: {
				background: "#21262E",
				speed: "1",
			},
		},
		popover: {
			menu: {
				background: "#30363D",
				boxShadow: "0px 0px 6px 0px black",
			},
		},
		banner: {
			background: "#161B22",
			padding: "40px",
			avatar: {
				background: "#fff",
				borderRadius: "50%",
			},
			headline: {
				foreground: "#fff",
			},
			title: {
				foreground: "#fff",
			},
			subtitle: {
				foreground: "#969696",
			},
			art: {
				foreground: "#21262E",
			},
		},
	},
});
