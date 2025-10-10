<script lang="ts">
import { _ } from "svelte-i18n";
import { goto } from "$app/navigation";
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
import { toast } from "svelte-sonner";
import * as Alert from "$lib/components/ui/alert";
import PeonyIcon from "$lib/components/icon/peony-icon.svelte";
import { register } from "$lib/services";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";
import { onMount } from "svelte";
import Logo from "$lib/components/logo/logo.svelte";

let firstName = $state("");
let lastName = $state("");
let email = $state("");
let password = $state("");
let confirmPassword = $state("");
let showPassword = $state(false);
let showConfirmPassword = $state(false);
let agreeTerms = $state(false);
let isLoading = $state(false);
let isError = $state(false);
let error = $state("");

async function handleSubmit(e: Event) {
	e.preventDefault();
	try {
		if (!agreeTerms) {
			throw new Error($_("auth.signup.agree_error"));
		}
		if (password !== confirmPassword) {
			throw new Error($_("auth.signup.password_error"));
		}
		isLoading = true;
		isError = false;
		error = "";
		await register(email, password, firstName, lastName);
		toast.success($_("auth.signup.toast_register", { values: { email } }));
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
	goto("/me");
});
</script>

<Meta
  title={$_('auth.signup.title')}
  description={$_('auth.signup.description')}
/>

<div
  class="relative min-h-screen flex items-center justify-center bg-gradient-to-br from-primary/5 via-accent/5 to-background p-4 overflow-hidden"
>
  <PeonyBackground />

  <div class="w-full max-w-md">
    <!-- Logo -->
    <div class="text-center mb-8">
      <div
        class="flex items-center justify-center gap-3 text-2xl font-bold mb-2"
      >
        <Logo />
      </div>
      <p class="text-muted-foreground">{$_('auth.signup.welcome')}</p>
    </div>

    <Card
      class="bg-gradient-to-br from-card/85 via-card/90 to-card/80 backdrop-blur-xl shadow-2xl shadow-primary/20"
    >
      <CardHeader class="text-center">
        <CardTitle class="text-2xl">{$_('auth.signup.title')}</CardTitle>
        <CardDescription>{$_('auth.signup.description')}</CardDescription>
      </CardHeader>
      <CardContent class="space-y-6">
        <form onsubmit={handleSubmit} class="space-y-4">
          <!-- Name Fields -->
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-2">
              <Label for="firstName">{$_('auth.signup.first_name')}</Label>
              <Input
                id="firstName"
                placeholder={$_('auth.signup.first_name_placeholder')}
                bind:value={firstName}
                required
                class="bg-background/50 border-primary/20 focus:border-primary"
              />
            </div>
            <div class="space-y-2">
              <Label for="lastName">{$_('auth.signup.last_name')}</Label>
              <Input
                id="lastName"
                placeholder={$_('auth.signup.last_name_placeholder')}
                bind:value={lastName}
                required
                class="bg-background/50 border-primary/20 focus:border-primary"
              />
            </div>
          </div>

          <!-- Email -->
          <div class="space-y-2">
            <Label for="email">{$_('auth.signup.email')}</Label>
            <Input
              id="email"
              type="email"
              placeholder={$_('auth.signup.email_placeholder')}
              bind:value={email}
              required
              class="bg-background/50 border-primary/20 focus:border-primary"
            />
          </div>

          <!-- Password -->
          <div class="space-y-2">
            <Label for="password">{$_('auth.signup.password')}</Label>
            <div class="relative">
              <Input
                id="password"
                type={showPassword ? 'text' : 'password'}
                placeholder={$_('auth.signup.password_placeholder')}
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

          <!-- Confirm Password -->
          <div class="space-y-2">
            <Label for="confirmPassword"
              >{$_('auth.signup.confirm_password')}</Label
            >
            <div class="relative">
              <Input
                id="confirmPassword"
                type={showConfirmPassword ? 'text' : 'password'}
                placeholder={$_('auth.signup.confirm_password_placeholder')}
                bind:value={confirmPassword}
                required
                class="bg-background/50 border-primary/20 focus:border-primary pr-10"
              />
              <button
                type="button"
                onclick={() => (showConfirmPassword = !showConfirmPassword)}
                class="cursor-pointer absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
              >
                {#if showConfirmPassword}
                  <span class="icon-[ri--eye-off-line] w-4 h-4"></span>
                {:else}
                  <span class="icon-[ri--eye-line] w-4 h-4"></span>
                {/if}
              </button>
            </div>
          </div>

          <!-- Terms Agreement -->
          <div class="flex items-start space-x-2">
            <Checkbox id="terms" bind:checked={agreeTerms} class="mt-1" />
            <Label for="terms" class="text-sm leading-relaxed">
              {$_('auth.signup.terms_agreement', {
                values: {
                  terms: $_('auth.signup.terms_of_service'),
                  privacy: $_('auth.signup.privacy_policy')
                }
              })}
            </Label>
          </div>

          {#if isError}
            <div class="grid w-full max-w-xl items-start gap-4">
              <Alert.Root variant="destructive">
                <Alert.Title class="items-center flex"
                  ><span class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                  ></span>{$_('auth.signup.error')}</Alert.Title
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
              {$_('auth.signup.creating_account')}
            {:else}
              {$_('auth.signup.create_account')}
            {/if}
          </Button>
        </form>

        <!-- Sign In Link -->
        <div class="text-center">
          <p class="text-sm text-muted-foreground">
            {$_('auth.signup.have_account')}
            <a href="/login" class="text-primary hover:underline font-medium"
              >{$_('auth.signup.sign_in_link')}</a
            >
          </p>
        </div>
      </CardContent>
    </Card>
  </div>
</div>
