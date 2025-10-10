<script>
import { _ } from "svelte-i18n";
import { Button } from "../ui/button";
import { Card, CardContent } from "../ui/card";
import NewsletterSignupPopup from "./newsletter-signup-popup.svelte";
let isPopupOpen = $state(false);

let { email = "" } = $props();
</script>

<!-- Newsletter Signup -->
<Card class="p-0 not-last:bg-gradient-to-br from-primary/10 to-accent/10">
  <CardContent class="p-6 text-center">
    <h3 class="font-semibold mb-2">{$_('newsletter_signup.title')}</h3>
    <p class="text-sm text-muted-foreground mb-4">
      {$_('newsletter_signup.description')}
    </p>
    <Button
      onclick={() => (isPopupOpen = true)}
      target="_blank"
      class="cursor-pointer w-full bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
      >{$_('newsletter_signup.cta')}</Button
    >
    <NewsletterSignupPopup bind:open={isPopupOpen} {email} />
  </CardContent>
</Card>
