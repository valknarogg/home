<script lang="ts">
import { _ } from "svelte-i18n";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogHeader,
	DialogTitle,
} from "$lib/components/ui/dialog";
import { Button } from "$lib/components/ui/button";
import { Separator } from "$lib/components/ui/separator";
import type { Snippet } from "svelte";
import Label from "../ui/label/label.svelte";
import Input from "../ui/input/input.svelte";
import { toast } from "svelte-sonner";

interface Props {
	open: boolean;
	email: string;
	children?: Snippet;
}

let isLoading = $state(false);

async function handleSubscription(e: Event) {
	e.preventDefault();
	try {
		isLoading = true;
		await fetch("/newsletter", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({ email }),
		});
		toast.success(
			$_("newsletter_signup.toast_subscribe", { values: { email } }),
		);
	} finally {
		isLoading = false;
		open = false;
	}
}

let { open = $bindable(), email = $bindable() }: Props = $props();
</script>

<Dialog bind:open>
  <DialogContent class="sm:max-w-md">
    <DialogHeader class="space-y-4">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div
            class="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-purple-600 flex items-center justify-center shrink-0 grow-0"
          >
            <span class="icon-[ri--newspaper-line]"></span>
          </div>
          <div class="">
            <DialogTitle
              class="text-left text-xl font-semibold text-primary-foreground"
              >{$_('newsletter_signup.title')}</DialogTitle
            >
            <DialogDescription class="text-left text-sm">
              {$_('newsletter_signup.description')}
            </DialogDescription>
          </div>
        </div>
      </div>
    </DialogHeader>

    <Separator class="my-4" />

    <form onsubmit={handleSubscription}>
      <!-- Email -->
      <div class="space-y-2 flex gap-4 items-center">
        <Label for="email" class="m-0">{$_('newsletter_signup.email')}</Label>
        <Input
          id="email"
          type="email"
          placeholder={$_('newsletter_signup.email_placeholder')}
          bind:value={email}
          required
          class="bg-background/50 border-primary/20 focus:border-primary"
        />
      </div>
      <Separator class="my-8" />

      <!-- Close Button -->
      <div class="flex justify-end gap-4">
        <Button
          variant="ghost"
          size="sm"
          onclick={() => (open = false)}
          class="text-muted-foreground hover:text-foreground cursor-pointer"
        >
          <span class="icon-[ri--close-large-line]"></span>
          {$_('newsletter_signup.close')}
        </Button>
        <Button
          variant="default"
          size="sm"
          type="submit"
          class="cursor-pointer"
          disabled={isLoading}
        >
          {#if isLoading}
            <div
              class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"
            ></div>
            {$_('newsletter_signup.subscribing')}
          {:else}
            <span class="icon-[ri--check-line]"></span>
            {$_('newsletter_signup.subscribe')}
          {/if}
        </Button>
      </div>
    </form>
  </DialogContent>
</Dialog>
