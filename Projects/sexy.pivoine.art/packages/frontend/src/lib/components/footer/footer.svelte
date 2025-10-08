<script lang="ts">
import { _ } from "svelte-i18n";
import PeonyIcon from "$lib/components/icon/peony-icon.svelte";
import Logo from "../logo/logo.svelte";
</script>

<footer
    class="bg-gradient-to-t from-card/95 to-card/85 backdrop-blur-xl mt-20 shadow-2xl shadow-primary/10"
>
    <div class="container mx-auto px-4 py-12">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
            <!-- Brand -->
            <div class="space-y-4">
                <div class="flex items-center gap-3 text-xl font-bold">
                    <Logo />
                </div>
                <p class="text-sm text-muted-foreground">{$_("brand.description")}</p>
                <div class="flex gap-3">
                    <a
                        aria-label="Email"
                        href="mailto:{$_('footer.contact.email')}"
                        class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center hover:bg-primary/20 transition-colors"
                    >
                        <span class="icon-[ri--mail-line] w-4 h-4 text-primary"></span>
                    </a>
                    <a
                        aria-label="X"
                        href="https://www.x.com/{$_('footer.contact.x')}"
                        class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center hover:bg-primary/20 transition-colors"
                    >
                        <span class="icon-[ri--twitter-x-line] w-4 h-4 text-primary"></span>
                    </a>
                    <a
                        aria-label="YouTube"
                        href="https://www.youtube.com/@{$_('footer.contact.youtube')}"
                        class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center hover:bg-primary/20 transition-colors"
                    >
                        <span class="icon-[ri--youtube-line] w-4 h-4 text-primary"></span>
                    </a>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="space-y-4">
                <h3 class="font-semibold text-foreground">
                    {$_("footer.quick_links")}
                </h3>
                <div class="space-y-2">
                    <a
                        href="/models"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.models")}</a
                    >
                    <a
                        href="/videos"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.videos")}</a
                    >
                    <a
                        href="/magazine"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.magazine")}</a
                    >
                    <a
                        href="/about"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.about")}</a
                    >
                </div>
            </div>

            <!-- Support -->
            <div class="space-y-4">
                <h3 class="font-semibold text-foreground">{$_("footer.support")}</h3>
                <div class="space-y-2">
                    <a
                        href="mailto:{$_('footer.contact_support_email')}"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.contact_support")}</a
                    >
                    <a
                        href="mailto:{$_('footer.model_applications_email')}"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.model_applications")}</a
                    >
                    <a
                        href="/faq"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.faq")}</a
                    >
                </div>
            </div>

            <!-- Legal -->
            <div class="space-y-4">
                <h3 class="font-semibold text-foreground">{$_("footer.legal")}</h3>
                <div class="space-y-2">
                    <a
                        href="/legal"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.privacy_policy")}</a
                    >
                    <a
                        href="/legal"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.terms_of_service")}</a
                    >
                    <a
                        href="/imprint"
                        class="block text-sm text-muted-foreground hover:text-primary transition-colors"
                        >{$_("footer.imprint")}</a
                    >
                </div>
            </div>
        </div>

        <div class="border-t border-border/50 mt-8 pt-8 text-center">
            <p class="text-sm text-muted-foreground">{$_("footer.copyright")}</p>
        </div>
    </div>
</footer>
