<script lang="ts">
import { Button } from "$lib/components/ui/button";

interface Props {
	onclick: () => void;
	icon: string;
	label: string;
}

let { onclick, icon, label }: Props = $props();
</script>

<button
    {onclick}
    aria-label={label}
    class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center hover:bg-primary/20 transition-colors cursor-pointer"
>
    <span class={icon + " w-4 h-4 text-primary"}></span>
</button>
