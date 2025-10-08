<script lang="ts">
import { _ } from "svelte-i18n";
import { goto } from "$app/navigation";
import { onMount } from "svelte";
import { toast } from "svelte-sonner";

onMount(() => {
	toast.success($_("auth.signup.toast_verify"));
	goto("/login");
});
</script>
