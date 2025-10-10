import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
	title: "Pivoine Docs - Documentation Hub",
	description:
		"Comprehensive documentation hub for all Pivoine projects by Valknar. Explore technical guides, API references, and tutorials.",
	keywords: [
		"documentation",
		"pivoine",
		"valknar",
		"developer",
		"guides",
		"api",
	],
	authors: [{ name: "Valknar", url: "https://pivoine.art" }],
	creator: "Valknar",
	manifest: "/manifest.json",
	icons: {
		icon: [
			{ url: "/favicon.svg", type: "image/svg+xml" },
			{ url: "/icon.svg", type: "image/svg+xml", sizes: "any" },
		],
		apple: [
			{ url: "/apple-touch-icon.png", sizes: "180x180", type: "image/png" },
		],
	},
	appleWebApp: {
		capable: true,
		statusBarStyle: "black-translucent",
		title: "Pivoine Docs",
	},
	openGraph: {
		type: "website",
		locale: "en_US",
		url: "https://docs.pivoine.art",
		title: "Pivoine Docs - Documentation Hub",
		description: "Comprehensive documentation hub for all Pivoine projects",
		siteName: "Pivoine Docs",
	},
	twitter: {
		card: "summary_large_image",
		title: "Pivoine Docs - Documentation Hub",
		description: "Comprehensive documentation hub for all Pivoine projects",
	},
	robots: {
		index: true,
		follow: true,
	},
};

export default function RootLayout({
	children,
}: {
	children: React.ReactNode;
}) {
	return (
		<html lang="en" className="scroll-smooth">
			<body className={inter.className}>{children}</body>
		</html>
	);
}
