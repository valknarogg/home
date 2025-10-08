<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import Meta from "$lib/components/meta/meta.svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";

const { data } = $props();

const stats = [
	{
		icon: "icon-[ri--user-heart-line]",
		value: data.stats.viewers_count,
		label: $_("about.stats.members"),
	},
	{
		icon: "icon-[ri--video-on-line]",
		value: data.stats.videos_count,
		label: $_("about.stats.videos"),
	},
	{
		icon: "icon-[ri--star-line]",
		value: data.stats.models_count,
		label: $_("about.stats.models"),
	},
	{
		icon: "icon-[ri--award-line]",
		value: $_("about.stats.yearsFormatted", { values: { years: 5 } }),
		label: $_("about.stats.experience"),
	},
];

const team = [
	{
		name: $_("about.team.sebastian.name"),
		role: $_("about.team.sebastian.role"),
		image: $_("about.team.sebastian.image"),
		bio: $_("about.team.sebastian.bio"),
	},
	{
		name: $_("about.team.valknar.name"),
		role: $_("about.team.valknar.role"),
		image: $_("about.team.valknar.image"),
		bio: $_("about.team.valknar.bio"),
	},
];

const values = [
	{
		icon: "icon-[ri--heart-line]",
		title: $_("about.values.authentic_expression.title"),
		description: $_("about.values.authentic_expression.description"),
	},
	{
		icon: "icon-[ri--shield-line]",
		title: $_("about.values.safety_respect.title"),
		description: $_("about.values.safety_respect.description"),
	},
	{
		icon: "icon-[ri--star-line]",
		title: $_("about.values.artistic_excellence.title"),
		description: $_("about.values.artistic_excellence.description"),
	},
	{
		icon: "icon-[ri--user-heart-line]",
		title: $_("about.values.community_first.title"),
		description: $_("about.values.community_first.description"),
	},
];
</script>

<Meta title={$_("about.title")} description={$_("about.subtitle")} />

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <PeonyBackground />

    <!-- Hero Section -->
    <section class="relative py-20 overflow-hidden">
        <div
            class="absolute inset-0 bg-gradient-to-br from-primary/10 via-accent/5 to-background"
        ></div>
        <div class="relative container mx-auto px-4 text-center">
            <div class="max-w-5xl mx-auto">
                <h1
                    class="text-5xl md:text-7xl font-bold mb-8 bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent"
                >
                    {$_("about.title")}
                </h1>
                <p
                    class="text-xl md:text-2xl text-muted-foreground mb-10 leading-relaxed max-w-4xl mx-auto"
                >
                    {$_("about.subtitle")}
                </p>
                <div class="flex justify-center">
                    <Button
                        size="lg"
                        class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                        href="/signup">{$_("about.join_community")}</Button
                    >
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="py-16 bg-card/30">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
                {#each stats as stat}
                    <div class="text-center">
                        <div
                            class="w-16 h-16 bg-gradient-to-br from-primary/20 to-accent/20 rounded-full flex items-center justify-center mx-auto mb-4"
                        >
                            <span class={stat.icon + " w-8 h-8 text-primary"}></span>
                        </div>
                        <div class="text-3xl font-bold text-primary mb-2">{stat.value}</div>
                        <div class="text-muted-foreground">{stat.label}</div>
                    </div>
                {/each}
            </div>
        </div>
    </section>

    <!-- Our Story Section -->
    <section class="py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-4xl mx-auto">
                <div class="text-center mb-12">
                    <h2 class="text-3xl md:text-4xl font-bold mb-4">
                        {$_("about.story.title")}
                    </h2>
                    <p class="text-lg text-muted-foreground">
                        {$_("about.story.subtitle")}
                    </p>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
                    <div class="space-y-6">
                        <p class="text-muted-foreground leading-relaxed text-lg">
                            {$_("about.story.description_part1")}
                        </p>
                        <p class="text-muted-foreground leading-relaxed text-lg">
                            {$_("about.story.description_part2")}
                        </p>
                        <p class="text-muted-foreground leading-relaxed text-lg">
                            {$_("about.story.description_part3")}
                        </p>
                    </div>
                    <div class="relative">
                        <img
                            src="/img/babes.jpg"
                            alt="Our story"
                            class="w-full object-cover rounded-2xl shadow-2xl"
                        />
                        <div
                            class="absolute inset-0 bg-gradient-to-t from-primary/20 to-transparent rounded-2xl"
                        ></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Values Section -->
    <section class="py-20 bg-card/30">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12">
                <h2 class="text-3xl md:text-4xl font-bold mb-4">
                    {$_("about.values.title")}
                </h2>
                <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
                    {$_("about.values.subtitle")}
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl mx-auto">
                {#each values as value}
                    <Card
                        class="bg-gradient-to-br from-card to-card/50 border-primary/20 hover:shadow-xl hover:shadow-primary/10 transition-all duration-300"
                    >
                        <CardContent class="p-6">
                            <div class="flex items-start gap-4">
                                <div
                                    class="w-12 h-12 bg-gradient-to-br from-primary/20 to-accent/20 rounded-full flex items-center justify-center flex-shrink-0"
                                >
                                    <span class={value.icon + " w-6 h-6 text-primary"}></span>
                                </div>
                                <div>
                                    <h3 class="font-semibold text-lg mb-2">{value.title}</h3>
                                    <p class="text-muted-foreground leading-relaxed">
                                        {value.description}
                                    </p>
                                </div>
                            </div>
                        </CardContent>
                    </Card>
                {/each}
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="py-20">
        <div class="container mx-auto px-4 max-w-xl">
            <div class="text-center mb-12">
                <h2 class="text-3xl md:text-4xl font-bold mb-4">
                    {$_("about.team.title")}
                </h2>
                <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
                    {$_("about.team.subtitle")}
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                {#each team as member}
                    <Card
                        class="bg-gradient-to-br from-card to-card/50 border-primary/20 hover:shadow-xl hover:shadow-primary/10 transition-all duration-300 hover:-translate-y-2"
                    >
                        <CardContent class="p-6 text-center">
                            <img
                                src={member.image}
                                alt={member.name}
                                class="w-24 h-24 rounded-full mx-auto mb-4 object-cover ring-4 ring-primary/20"
                            />
                            <h3 class="font-semibold text-lg mb-1">{member.name}</h3>
                            <p class="text-primary text-sm mb-3">{member.role}</p>
                            <p class="text-muted-foreground text-sm leading-relaxed">
                                {member.bio}
                            </p>
                        </CardContent>
                    </Card>
                {/each}
            </div>
        </div>
    </section>

    <!-- Mission Section -->
    <section class="py-20 bg-gradient-to-r from-primary/10 via-accent/10 to-primary/10">
        <div class="container mx-auto px-4 text-center">
            <div class="max-w-4xl mx-auto">
                <h2 class="text-3xl md:text-4xl font-bold mb-6">
                    {$_("about.mission.title")}
                </h2>
                <p class="text-xl text-muted-foreground mb-8 leading-relaxed">
                    {$_("about.mission.description")}
                </p>
                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <Button
                        size="lg"
                        class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                        href="/signup">{$_("about.mission.cta_creator")}</Button
                    >

                    <Button
                        variant="outline"
                        size="lg"
                        class="border-primary/50 hover:bg-primary/10"
                        href="/signup">{$_("about.mission.cta_community")}</Button
                    >
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="py-20">
        <div class="container mx-auto px-4">
            <div class="max-w-2xl mx-auto text-center">
                <h2 class="text-3xl md:text-4xl font-bold mb-6">
                    {$_("about.contact.title")}
                </h2>
                <p class="text-lg text-muted-foreground mb-8">
                    {$_("about.contact.description")}
                </p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                        <CardContent class="p-6 text-center">
                            <h3 class="font-semibold mb-2">
                                {$_("about.contact.general.title")}
                            </h3>
                            <p class="text-muted-foreground text-sm mb-4">
                                {$_("about.contact.general.description")}
                            </p>
                            <a
                                href="mailto:{$_('about.contact.general.mailto')}"
                                class="text-primary hover:underline"
                                >{$_("about.contact.general.mailto")}</a
                            >
                        </CardContent>
                    </Card>
                    <Card class="bg-gradient-to-br from-card to-card/50 border-primary/20">
                        <CardContent class="p-6 text-center">
                            <h3 class="font-semibold mb-2">
                                {$_("about.contact.creators.title")}
                            </h3>
                            <p class="text-muted-foreground text-sm mb-4">
                                {$_("about.contact.creators.description")}
                            </p>
                            <a
                                href="mailto:{$_('about.contact.creators.mailto')}"
                                class="text-primary hover:underline"
                                >{$_("about.contact.creators.mailto")}</a
                            >
                        </CardContent>
                    </Card>
                </div>
            </div>
        </div>
    </section>
</div>
