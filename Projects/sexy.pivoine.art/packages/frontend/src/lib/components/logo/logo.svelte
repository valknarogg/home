<script lang="ts">
import { _ } from "svelte-i18n";
import PeonyIcon from "../icon/peony-icon.svelte";

const { hideName = false } = $props();
</script>

<div class="relative">
  <PeonyIcon class="w-13 h-13 text-black" />
</div>
<span
  class={`logo text-3xl text-foreground opacity-90 tracking-wide font-extrabold drop-shadow-x ${hideName ? "hidden sm:inline-block" : ""}`}
>
  {$_('brand.name')}
</span>

<style>
  .logo {
    font-family: 'Dancing Script', cursive;
  }
</style>
