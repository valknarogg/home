// See https://svelte.dev/docs/kit/types#app.d.ts

import type { AuthStatus } from "$lib/types";

// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		interface Locals {
			authStatus: AuthStatus;
		}
		// interface PageData {}
		// interface PageState {}
		// interface Platform {}
	}
	interface Window {
		sidebar: {
			addPanel: () => void;
		};
		opera: object;
	}
}

export {};
