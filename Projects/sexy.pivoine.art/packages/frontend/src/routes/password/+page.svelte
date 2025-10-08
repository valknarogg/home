<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "$lib/components/ui/card";
import { Input } from "$lib/components/ui/input";
import { Label } from "$lib/components/ui/label";
import PeonyIcon from "$lib/components/icon/peony-icon.svelte";
import * as Alert from "$lib/components/ui/alert";
import { goto } from "$app/navigation";
import { login, requestPassword } from "$lib/services";
import { onMount } from "svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import { toast } from "svelte-sonner";
import Meta from "$lib/components/meta/meta.svelte";
import Logo from "$lib/components/logo/logo.svelte";

let email = $state("");
let error = $state("");
let isLoading = $state(false);
let isError = $state(false);

async function handleSubmit(e: Event) {
	e.preventDefault();
	try {
		await requestPassword(email);
		toast.success(
			$_("auth.password_request.toast_request", { values: { email } }),
		);
		goto("/login");
	} catch (err: any) {
		error = err.message;
		isError = true;
	} finally {
		isLoading = false;
	}
}

const { data } = $props();

onMount(() => {
	if (!data.authStatus.authenticated) {
		return;
	}
	goto("/");
});
</script>

<Meta
    title={$_("auth.password_request.title")}
    description={$_("auth.password_request.description")}
/>

<div
    class="relative min-h-screen flex items-center justify-center bg-gradient-to-br from-primary/5 via-accent/5 to-background p-4 overflow-hidden"
>
    <PeonyBackground />

    <div class="w-full max-w-md">
        <!-- Logo -->
        <div class="text-center mb-8">
            <div class="flex items-center justify-center gap-3 text-2xl font-bold mb-2">
                
                <Logo />
            </div>
            <p class="text-muted-foreground">{$_("auth.password_request.welcome")}</p>
        </div>

        <Card
            class="bg-gradient-to-br from-card/85 via-card/90 to-card/80 backdrop-blur-xl shadow-2xl shadow-primary/20"
        >
            <CardHeader class="text-center">
                <CardTitle class="text-2xl">{$_("auth.password_request.title")}</CardTitle>
                <CardDescription>{$_("auth.password_request.description")}</CardDescription>
            </CardHeader>
            <CardContent class="space-y-6">
                <form onsubmit={handleSubmit} class="space-y-4">
                    <!-- Email -->
                    <div class="space-y-2">
                        <Label for="email">{$_("auth.password_request.email")}</Label>
                        <Input
                            id="email"
                            type="email"
                            placeholder={$_("auth.password_request.email_placeholder")}
                            bind:value={email}
                            required
                            class="bg-background/50 border-primary/20 focus:border-primary"
                        />
                    </div>

                    {#if isError}
                        <div class="grid w-full max-w-xl items-start gap-4">
                            <Alert.Root variant="destructive">
                                <Alert.Title class="items-center flex"
                                    ><span class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                                    ></span>{$_("auth.password_request.error")}</Alert.Title
                                >
                                <Alert.Description>{error}</Alert.Description>
                            </Alert.Root>
                        </div>
                    {/if}

                    <!-- Submit Button -->
                    <Button
                        type="submit"
                        class="cursor-pointer w-full bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                        disabled={isLoading}
                    >
                        {#if isLoading}
                            <div
                                class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"
                            ></div>
                            {$_("auth.password_request.requesting")}
                        {:else}
                            {$_("auth.password_request.request")}
                        {/if}
                    </Button>
                </form>
            </CardContent>
        </Card>
    </div>
</div>
