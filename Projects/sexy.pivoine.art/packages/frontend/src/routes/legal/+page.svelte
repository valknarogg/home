<script lang="ts">
import { _ } from "svelte-i18n";
import {
	Card,
	CardContent,
	CardHeader,
	CardTitle,
} from "$lib/components/ui/card";
import {
	Tabs,
	TabsContent,
	TabsList,
	TabsTrigger,
} from "$lib/components/ui/tabs";
import { Separator } from "$lib/components/ui/separator";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";

let activeTab = $state("privacy");
</script>

<Meta title={$_("legal.title")} description={$_("legal.description")} />

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <PeonyBackground />

    <div class="container mx-auto py-20 relative px-4">
        <div class="max-w-4xl mx-auto">
            <!-- Header -->
            <div class="text-center mb-12">
                <h1
                    class="text-4xl md:text-5xl font-bold mb-4 bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent"
                >
                    {$_("legal.title")}
                </h1>
                <p class="text-lg text-muted-foreground">
                    {$_("legal.description")}
                </p>
            </div>

            <!-- Legal Tabs -->
            <Tabs bind:value={activeTab} class="w-full">
                <TabsList class="h-auto grid w-full grid-cols-1 md:grid-cols-4 mb-8">
                    <TabsTrigger value="privacy" class="flex items-center gap-2">
                        <span class="icon-[ri--shield-line] w-4 h-4"></span>
                        {$_("legal.privacy.title")}
                    </TabsTrigger>
                    <TabsTrigger value="terms" class="flex items-center gap-2">
                        <span class="icon-[ri--file-list-3-line] w-4 h-4"></span>
                        {$_("legal.terms.title")}
                    </TabsTrigger>
                    <TabsTrigger value="community" class="flex items-center gap-2">
                        <span class="icon-[ri--eye-line] w-4 h-4"></span>
                        {$_("legal.community.title")}
                    </TabsTrigger>
                    <TabsTrigger value="cookies" class="flex items-center gap-2">
                        <span class="icon-[ri--cake-3-line] w-4 h-4"></span>
                        {$_("legal.cookie.title")}
                    </TabsTrigger>
                </TabsList>

                <!-- Privacy Policy -->
                <TabsContent value="privacy">
                    <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                        <CardHeader>
                            <CardTitle class="flex items-center gap-2">
                                <span class="icon-[ri--shield-line] w-5 h-5 text-primary"></span>
                                {$_("legal.privacy.title")}
                            </CardTitle>
                            <p class="text-muted-foreground">
                                {$_("legal.privacy.last_updated")}
                            </p>
                        </CardHeader>
                        <CardContent class="space-y-6">
                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.privacy.information.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>
                                        {@html $_("legal.privacy.information.text.0")}
                                    </p>
                                    <p>
                                        {@html $_("legal.privacy.information.text.1")}
                                    </p>
                                    <!-- <p>
                    <strong>Usage Information:</strong>
                    We automatically collect information about how you use our services,
                    including your IP address, browser type, and device information.
                  </p> -->
                                    <!-- <p>
                    <strong>Payment Information:</strong>
                    When you make purchases, we collect payment information through
                    secure third-party processors.
                  </p> -->
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.privacy.information_use.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>{$_("legal.privacy.information_use.subtitle")}</p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.privacy.information_use.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.privacy.information_sharing.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>
                                        {$_("legal.privacy.information_sharing.subtitle")}
                                    </p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.privacy.information_sharing.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.privacy.security.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.privacy.security.text.0")}
                                </p>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.privacy.rights.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>{$_("legal.privacy.rights.subtitle")}</p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.privacy.rights.text.0")}
                                    </ul>
                                </div>
                            </div>
                        </CardContent>
                    </Card>
                </TabsContent>

                <!-- Terms of Service -->
                <TabsContent value="terms">
                    <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                        <CardHeader>
                            <CardTitle class="flex items-center gap-2">
                                <span class="icon-[ri--file-list-3-line] w-5 h-5 text-primary"
                                ></span>
                                {$_("legal.terms.title")}
                            </CardTitle>
                            <p class="text-muted-foreground">
                                {$_("legal.terms.last_updated")}
                            </p>
                        </CardHeader>
                        <CardContent class="space-y-6">
                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.terms.acceptance.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.terms.acceptance.text.0")}
                                </p>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.terms.age.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.terms.age.text.0")}
                                </p>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.terms.accounts.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>{$_("legal.terms.accounts.subtitle")}</p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.terms.accounts.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.terms.content.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>
                                        {$_("legal.terms.content.subtitle")}
                                    </p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.terms.content.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.terms.payment.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>{$_("legal.terms.payment.subtitle")}</p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.terms.payment.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.terms.termination.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.terms.termination.text.0")}
                                </p>
                            </div>
                        </CardContent>
                    </Card>
                </TabsContent>

                <!-- Community Guidelines -->
                <TabsContent value="community">
                    <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                        <CardHeader>
                            <CardTitle class="flex items-center gap-2">
                                <span class="icon-[ri--eye-line] w-5 h-5 text-primary"></span>
                                {$_("legal.community.title")}
                            </CardTitle>
                            <p class="text-muted-foreground">
                                {$_("legal.community.description")}
                            </p>
                        </CardHeader>
                        <CardContent class="space-y-6">
                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.community.values.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.community.values.text.0")}
                                </p>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.community.respect.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.community.respect.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.community.standards.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.community.standards.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.community.interaction.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.community.interaction.text.0")}
                                    </ul>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.community.enforcement.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.community.enforcement.text.0")}
                                </p>
                            </div>
                        </CardContent>
                    </Card>
                </TabsContent>

                <!-- Cookie Policy -->
                <TabsContent value="cookies">
                    <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                        <CardHeader>
                            <CardTitle class="flex items-center gap-2">
                                <span class="icon-[ri--cake-3-line] w-5 h-5 text-primary"></span>
                                {$_("legal.cookie.title")}
                            </CardTitle>
                            <p class="text-muted-foreground">
                                {$_("legal.cookie.description")}
                            </p>
                        </CardHeader>
                        <CardContent class="space-y-6">
                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.cookie.what.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.cookie.what.text.0")}
                                </p>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.cookie.types.title")}
                                </h3>
                                <div class="space-y-4">
                                    <div>
                                        <h4 class="font-medium mb-2">
                                            {$_("legal.cookie.types.essential.title")}
                                        </h4>
                                        <p class="text-muted-foreground text-sm">
                                            {@html $_("legal.cookie.types.essential.text.0")}
                                        </p>
                                    </div>
                                    <!-- <div>
                    <h4 class="font-medium mb-2">Performance Cookies</h4>
                    <p class="text-muted-foreground text-sm">
                      These cookies collect information about how visitors use
                      our website, helping us improve performance and user
                      experience.
                    </p>
                  </div>
                  <div>
                    <h4 class="font-medium mb-2">Functionality Cookies</h4>
                    <p class="text-muted-foreground text-sm">
                      These cookies remember your preferences and settings to
                      provide a more personalized experience.
                    </p>
                  </div>
                  <div>
                    <h4 class="font-medium mb-2">Analytics Cookies</h4>
                    <p class="text-muted-foreground text-sm">
                      These cookies help us understand how our website is being
                      used and how we can improve it.
                    </p>
                  </div> -->
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.cookie.managing.title")}
                                </h3>
                                <div class="space-y-3 text-muted-foreground">
                                    <p>{$_("legal.cookie.managing.subtitle")}</p>
                                    <ul class="list-disc pl-6 space-y-1">
                                        {@html $_("legal.cookie.managing.text.0")}
                                    </ul>
                                    <p>
                                        {@html $_("legal.cookie.managing.text.1")}
                                    </p>
                                </div>
                            </div>

                            <Separator />

                            <div>
                                <h3 class="text-lg font-semibold mb-3">
                                    {$_("legal.cookie.third_party.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {@html $_("legal.cookie.third_party.text.0")}
                                </p>
                            </div>
                        </CardContent>
                    </Card>
                </TabsContent>
            </Tabs>

            <!-- Contact Information -->
            <Card class="mt-8 bg-gradient-to-br from-card to-card/50 border-primary/20">
                <CardContent class="p-6 text-center">
                    <h3 class="font-semibold mb-2">
                        {$_("legal.questions")}
                    </h3>
                    <p class="text-muted-foreground mb-4">
                        {$_("legal.questions_description")}
                    </p>
                    <a
                        href="mailto:{$_('legal.questions_email')}"
                        class="text-primary hover:underline">{$_("legal.questions_email")}</a
                    >
                </CardContent>
            </Card>
        </div>
    </div>
</div>
