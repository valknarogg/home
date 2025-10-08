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
import { resetPassword } from "$lib/services";
import { onMount } from "svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import { toast } from "svelte-sonner";
import Meta from "$lib/components/meta/meta.svelte";
import Logo from "$lib/components/logo/logo.svelte";

let error = $state("");
let isLoading = $state(false);
let isError = $state(false);
let password = $state("");
let confirmPassword = $state("");
let showPassword = $state(false);
let showConfirmPassword = $state(false);

async function handleSubmit(e: Event) {
	e.preventDefault();
	try {
		if (password !== confirmPassword) {
			throw new Error($_("auth.password_reset.password_error"));
		}
		isLoading = true;
		isError = false;
		error = "";
		await resetPassword(data.token, password);
		toast.success($_("auth.password_reset.toast_reset"));
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

<Meta title={$_("auth.password_reset.title")} description={$_("auth.password_reset.description")} />

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
            <p class="text-muted-foreground">{$_("auth.password_reset.welcome")}</p>
        </div>

        <Card
            class="bg-gradient-to-br from-card/85 via-card/90 to-card/80 backdrop-blur-xl shadow-2xl shadow-primary/20"
        >
            <CardHeader class="text-center">
                <CardTitle class="text-2xl">{$_("auth.password_reset.title")}</CardTitle>
                <CardDescription>{$_("auth.password_reset.description")}</CardDescription>
            </CardHeader>
            <CardContent class="space-y-6">
                <form onsubmit={handleSubmit} class="space-y-4">
                    <!-- Password -->
                    <div class="space-y-2">
                        <Label for="password">{$_("auth.password_reset.password")}</Label>
                        <div class="relative">
                            <Input
                                id="password"
                                type={showPassword ? "text" : "password"}
                                placeholder={$_("auth.password_reset.password_placeholder")}
                                bind:value={password}
                                required
                                class="bg-background/50 border-primary/20 focus:border-primary pr-10"
                            />
                            <button
                                type="button"
                                onclick={() => (showPassword = !showPassword)}
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                            >
                                {#if showPassword}
                                    <span class="icon-[ri--eye-off-line] w-4 h-4"></span>
                                {:else}
                                    <span class="icon-[ri--eye-line] w-4 h-4"></span>
                                {/if}
                            </button>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="space-y-2">
                        <Label for="confirmPassword"
                            >{$_("auth.password_reset.confirm_password")}</Label
                        >
                        <div class="relative">
                            <Input
                                id="confirmPassword"
                                type={showConfirmPassword ? "text" : "password"}
                                placeholder={$_("auth.password_reset.confirm_password_placeholder")}
                                bind:value={confirmPassword}
                                required
                                class="bg-background/50 border-primary/20 focus:border-primary pr-10"
                            />
                            <button
                                type="button"
                                onclick={() => (showConfirmPassword = !showConfirmPassword)}
                                class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                            >
                                {#if showConfirmPassword}
                                    <span class="icon-[ri--eye-off-line] w-4 h-4"></span>
                                {:else}
                                    <span class="icon-[ri--eye-line] w-4 h-4"></span>
                                {/if}
                            </button>
                        </div>
                    </div>

                    {#if isError}
                        <div class="grid w-full max-w-xl items-start gap-4">
                            <Alert.Root variant="destructive">
                                <Alert.Title class="items-center flex"
                                    ><span class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                                    ></span>{$_("auth.password_reset.error")}</Alert.Title
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
                            {$_("auth.password_reset.resetting")}
                        {:else}
                            {$_("auth.password_reset.reset")}
                        {/if}
                    </Button>
                </form>
            </CardContent>
        </Card>
    </div>
</div>
