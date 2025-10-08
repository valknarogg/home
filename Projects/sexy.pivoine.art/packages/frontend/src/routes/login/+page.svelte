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
import { Checkbox } from "$lib/components/ui/checkbox";
import PeonyIcon from "$lib/components/icon/peony-icon.svelte";
import * as Alert from "$lib/components/ui/alert";
import { goto } from "$app/navigation";
import { login } from "$lib/services";
import { onMount } from "svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";
import Logo from "$lib/components/logo/logo.svelte";

let email = $state("");
let password = $state("");
let error = $state("");
let showPassword = $state(false);
let rememberMe = $state(false);
let isLoading = $state(false);
let isError = $state(false);

async function handleSubmit(e: Event) {
	e.preventDefault();
	try {
		await login(email, password);
		goto("/videos", { invalidateAll: true });
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
	goto("/me");
});
</script>

<Meta title={$_("auth.login.title")} description={$_("auth.login.description")} />

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
            <p class="text-muted-foreground">{$_("auth.login.welcome")}</p>
        </div>

        <Card
            class="bg-gradient-to-br from-card/85 via-card/90 to-card/80 backdrop-blur-xl shadow-2xl shadow-primary/20"
        >
            <CardHeader class="text-center">
                <CardTitle class="text-2xl">{$_("auth.login.title")}</CardTitle>
                <CardDescription>{$_("auth.login.description")}</CardDescription>
            </CardHeader>
            <CardContent class="space-y-6">
                <form onsubmit={handleSubmit} class="space-y-4">
                    <!-- Email -->
                    <div class="space-y-2">
                        <Label for="email">{$_("auth.login.email")}</Label>
                        <Input
                            id="email"
                            type="email"
                            placeholder={$_("auth.login.email_placeholder")}
                            bind:value={email}
                            required
                            class="bg-background/50 border-primary/20 focus:border-primary"
                        />
                    </div>

                    <!-- Password -->
                    <div class="space-y-2">
                        <Label for="password">{$_("auth.login.password")}</Label>
                        <div class="relative">
                            <Input
                                id="password"
                                type={showPassword ? "text" : "password"}
                                placeholder={$_("auth.login.password_placeholder")}
                                bind:value={password}
                                required
                                class="bg-background/50 border-primary/20 focus:border-primary pr-10"
                            />
                            <button
                                type="button"
                                onclick={() => (showPassword = !showPassword)}
                                class="cursor-pointer absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                            >
                                {#if showPassword}
                                    <span class="icon-[ri--eye-off-line] w-4 h-4"></span>
                                {:else}
                                    <span class="icon-[ri--eye-line] w-4 h-4"></span>
                                {/if}
                            </button>
                        </div>
                    </div>

                    <!-- Remember Me & Forgot Password -->
                    <div class="flex items-center justify-between">
                        <!-- <div class="flex items-center space-x-2">
              <Checkbox id="remember" bind:checked={rememberMe} />
              <Label for="remember" class="text-sm"
                >{$_("auth.login.remember_me")}</Label
              >
            </div> -->
                        <a href="/password" class="text-sm text-primary hover:underline"
                            >{$_("auth.login.forgot_password")}</a
                        >
                    </div>

                    {#if isError}
                        <div class="grid w-full max-w-xl items-start gap-4">
                            <Alert.Root variant="destructive">
                                <Alert.Title class="items-center flex"
                                    ><span class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                                    ></span>{$_("auth.login.error")}</Alert.Title
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
                            {$_("auth.login.signing_in")}
                        {:else}
                            {$_("auth.login.sign_in")}
                        {/if}
                    </Button>
                </form>

                <!-- Divider -->
                <!-- <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-border/50"></div>
          </div>
          <div class="relative flex justify-center text-xs uppercase">
            <span class="bg-card px-2 text-muted-foreground"
              >{$_("auth.login.or_continue")}</span
            >
          </div>
        </div> -->

                <!-- Social Login -->
                <!-- <div class="grid grid-cols-2 gap-4">
          <Button
            variant="outline"
            class="border-primary/20 hover:bg-primary/10"
          >
            <svg class="w-4 h-4 mr-2" viewBox="0 0 24 24">
              <path
                fill="currentColor"
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
              />
              <path
                fill="currentColor"
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              />
              <path
                fill="currentColor"
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              />
              <path
                fill="currentColor"
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              />
            </svg>
            Google
          </Button>
          <Button
            variant="outline"
            class="border-primary/20 hover:bg-primary/10"
          >
            <svg class="w-4 h-4 mr-2" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"
              />
            </svg>
            Facebook
          </Button>
        </div> -->

                <!-- Sign Up Link -->
                <div class="text-center">
                    <p class="text-sm text-muted-foreground">
                        {$_("auth.login.no_account")}{" "}
                        <a href="/signup" class="text-primary hover:underline font-medium"
                            >{$_("auth.login.sign_up_link")}</a
                        >
                    </p>
                </div>
            </CardContent>
        </Card>
    </div>
</div>
