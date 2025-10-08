<script lang="ts">
import { _ } from "svelte-i18n";
import {
	Card,
	CardContent,
	CardHeader,
	CardTitle,
} from "$lib/components/ui/card";
import { Separator } from "$lib/components/ui/separator";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";
</script>

<Meta title={$_("imprint.title")} description={$_("imprint.description")} />

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
                    {$_("imprint.title")}
                </h1>
                <p class="text-lg text-muted-foreground">
                    {$_("imprint.description")}
                </p>
            </div>

            <!-- Company Information -->
            <Card class="mb-8 bg-gradient-to-br from-card to-card/50 border-primary/20">
                <CardHeader>
                    <CardTitle class="flex items-center gap-2">
                        <span class="icon-[ri--building-2-line] w-5 h-5 text-primary"></span>
                        {$_("imprint.company_information")}
                    </CardTitle>
                </CardHeader>
                <CardContent class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <h3 class="font-semibold mb-2">
                                {$_("imprint.company_name.title")}
                            </h3>
                            <p class="text-muted-foreground">
                                {$_("imprint.company_name.value")}
                            </p>
                        </div>
                        <div>
                            <h3 class="font-semibold mb-2">
                                {$_("imprint.legal_form.title")}
                            </h3>
                            <p class="text-muted-foreground">
                                {$_("imprint.legal_form.value")}
                            </p>
                        </div>
                        <div>
                            <h3 class="font-semibold mb-2">
                                {$_("imprint.registration_number.title")}
                            </h3>
                            <p class="text-muted-foreground">
                                {$_("imprint.registration_number.value")}
                            </p>
                        </div>
                        <div>
                            <h3 class="font-semibold mb-2">{$_("imprint.tax_id.title")}</h3>
                            <p class="text-muted-foreground">{$_("imprint.tax_id.value")}</p>
                        </div>
                    </div>
                </CardContent>
            </Card>

            <!-- Contact Information -->
            <Card class="mb-8 bg-gradient-to-br from-card to-card/50 border-primary/20">
                <CardHeader>
                    <CardTitle class="flex items-center gap-2">
                        <span class="icon-[ri--mail-line] w-5 h-5 text-primary"></span>
                        {$_("imprint.contact_information")}
                    </CardTitle>
                </CardHeader>
                <CardContent class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <h3 class="font-semibold mb-2">
                                {$_("imprint.registered_address")}
                            </h3>
                            <div class="text-muted-foreground">
                                <p>{$_("imprint.address.company")}</p>
                                <p>{$_("imprint.address.name")}</p>
                                <p>{$_("imprint.address.street")}</p>
                                <p>{$_("imprint.address.city")}</p>
                                <p>{$_("imprint.address.country")}</p>
                            </div>
                        </div>
                        <!-- <div>
              <h3 class="font-semibold mb-2">Business Address</h3>
              <div class="text-muted-foreground">
                <p>Sexy.Art Studios</p>
                <p>5678 Hollywood Drive</p>
                <p>Floor 12</p>
                <p>Los Angeles, CA 90028</p>
                <p>United States</p>
              </div>
            </div> -->
                    </div>

                    <Separator />

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div class="flex items-start gap-3">
                            <span class="icon-[ri--phone-line] w-5 h-5 text-primary mt-0.5"></span>
                            <div>
                                <h3 class="font-semibold mb-1">{$_("imprint.phone.title")}</h3>
                                <p class="text-muted-foreground">{$_("imprint.phone.value")}</p>
                            </div>
                        </div>
                        <div class="flex items-start gap-3">
                            <span class="icon-[ri--mail-line] w-5 h-5 text-primary mt-0.5"></span>
                            <div>
                                <h3 class="font-semibold mb-1">{$_("imprint.email.title")}</h3>
                                <p class="text-muted-foreground">{$_("imprint.email.value")}</p>
                            </div>
                        </div>
                        <div class="flex items-start gap-3">
                            <span class="icon-[ri--global-line] w-5 h-5 text-primary mt-0.5"></span>
                            <div>
                                <h3 class="font-semibold mb-1">
                                    {$_("imprint.website.title")}
                                </h3>
                                <p class="text-muted-foreground">
                                    {$_("imprint.website.value")}
                                </p>
                            </div>
                        </div>
                    </div>
                </CardContent>
            </Card>

            <!-- Management -->
            <!-- <Card
        class="mb-8 bg-gradient-to-br from-card to-card/50 border-primary/20"
      >
        <CardHeader>
          <CardTitle>Management & Representation</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <h3 class="font-semibold mb-2">Chief Executive Officer</h3>
            <p class="text-muted-foreground">Alexandra Chen</p>
          </div>
          <div>
            <h3 class="font-semibold mb-2">Chief Technology Officer</h3>
            <p class="text-muted-foreground">David Kim</p>
          </div>
          <div>
            <h3 class="font-semibold mb-2">Legal Representative</h3>
            <p class="text-muted-foreground">
              Johnson & Associates Law Firm
              <br />
              Attorney Michael Johnson
              <br />
              789 Legal Plaza, Suite 101
              <br />
              Los Angeles, CA 90210
              <br />
              Phone: +1 (555) 987-6543
            </p>
          </div>
        </CardContent>
      </Card> -->

            <!-- Regulatory Information -->
            <!-- <Card
        class="mb-8 bg-gradient-to-br from-card to-card/50 border-primary/20"
      >
        <CardHeader>
          <CardTitle>Regulatory Information</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <h3 class="font-semibold mb-2">Industry Classification</h3>
            <p class="text-muted-foreground">
              NAICS Code: 518210 - Data Processing, Hosting, and Related
              Services
              <br />
              SIC Code: 7374 - Computer Processing and Data Preparation Services
            </p>
          </div>
          <div>
            <h3 class="font-semibold mb-2">Content Rating</h3>
            <p class="text-muted-foreground">
              This platform contains adult content and is restricted to users 18
              years and older.
              <br />
              RTA Label: RTA-5042-1996-1400-1577-RTA
            </p>
          </div>
          <div>
            <h3 class="font-semibold mb-2">Compliance</h3>
            <p class="text-muted-foreground">
              • 18 U.S.C. § 2257 Record-Keeping Requirements Compliance
              Statement
              <br />
              • GDPR Compliance (EU General Data Protection Regulation)
              <br />
              • CCPA Compliance (California Consumer Privacy Act)
              <br />
              • COPPA Compliance (Children's Online Privacy Protection Act)
            </p>
          </div>
        </CardContent>
      </Card> -->

            <!-- Technical Information -->
            <!-- <Card
        class="mb-8 bg-gradient-to-br from-card to-card/50 border-primary/20"
      >
        <CardHeader>
          <CardTitle>Technical Information</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <h3 class="font-semibold mb-2">Hosting Provider</h3>
            <p class="text-muted-foreground">
              CloudTech Solutions Inc.
              <br />
              Data Center Location: United States
              <br />
              Security Certification: SOC 2 Type II, ISO 27001
            </p>
          </div>
          <div>
            <h3 class="font-semibold mb-2">Content Delivery Network</h3>
            <p class="text-muted-foreground">
              Global CDN Services
              <br />
              SSL Certificate: Extended Validation (EV)
              <br />
              Encryption: TLS 1.3
            </p>
          </div>
        </CardContent>
      </Card> -->

            <!-- Disclaimer -->
            <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                <CardHeader>
                    <CardTitle>{$_("imprint.disclaimer")}</CardTitle>
                </CardHeader>
                <CardContent class="space-y-4">
                    <p class="text-muted-foreground leading-relaxed">
                        {$_("imprint.disclaimer_text.0")}
                    </p>
                    <p class="text-muted-foreground leading-relaxed">
                        {$_("imprint.disclaimer_text.1")}
                    </p>
                    <p class="text-muted-foreground leading-relaxed">
                        {$_("imprint.disclaimer_text.2")}
                    </p>
                </CardContent>
            </Card>

            <!-- Last Updated -->
            <div class="text-center mt-8 text-sm text-muted-foreground">
                <p>{$_("imprint.last_updated")}</p>
            </div>
        </div>
    </div>
</div>
