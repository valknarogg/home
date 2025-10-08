<script lang="ts">
import { _ } from "svelte-i18n";
import { PUBLIC_URL } from "$env/static/public";

interface Props {
	title: string;
	description: string;
	image?: string;
}

let {
	title,
	description,
	image = `${PUBLIC_URL}/img/kamasutra.jpg`,
}: Props = $props();
</script>

<svelte:head>
    <title>{$_("head.title", { values: { title } })}</title>
    <meta name="description" content={description} />
    <meta property="og:title" content={$_("head.title", { values: { title } })} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={image} />
</svelte:head>
