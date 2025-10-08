<script lang="ts">
import { _ } from "svelte-i18n";
import {
	Card,
	CardContent,
	CardHeader,
	CardTitle,
} from "$lib/components/ui/card";
import { Input } from "$lib/components/ui/input";
import { Button } from "$lib/components/ui/button";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";

let searchQuery = $state("");
let expandedItems = $state<Set<number>>(new Set());

const faqCategories = [
	{
		id: 1,
		title: $_("faq.getting_started.title"),
		icon: "icon-[ri--home-heart-line]",
		questions: [
			{
				id: 1,
				question: $_("faq.getting_started.questions.0.question"),
				answer: $_("faq.getting_started.questions.0.answer"),
			},
			{
				id: 2,
				question: $_("faq.getting_started.questions.1.question"),
				answer: $_("faq.getting_started.questions.1.answer"),
			},
			{
				id: 3,
				question: $_("faq.getting_started.questions.2.question"),
				answer: $_("faq.getting_started.questions.2.answer"),
			},
			{
				id: 4,
				question: $_("faq.getting_started.questions.3.question"),
				answer: $_("faq.getting_started.questions.3.answer"),
			},
		],
	},
	{
		id: 2,
		title: $_("faq.creators.title"),
		icon: "icon-[ri--user-heart-line]",
		questions: [
			{
				id: 5,
				question: $_("faq.creators.questions.0.question"),
				answer: $_("faq.creators.questions.0.answer"),
			},
			{
				id: 6,
				question: $_("faq.creators.questions.1.question"),
				answer: $_("faq.creators.questions.1.answer"),
			},
			{
				id: 7,
				question: $_("faq.creators.questions.2.question"),
				answer: $_("faq.creators.questions.2.answer"),
			},
			{
				id: 8,
				question: $_("faq.creators.questions.3.question"),
				answer: $_("faq.creators.questions.3.answer"),
			},
		],
	},
	// {
	//   id: 3,
	//   title: $_("faq.categories.payments"),
	//   icon: CreditCardIcon,
	//   questions: [
	//     {
	//       id: 9,
	//       question: "What payment methods do you accept?",
	//       answer:
	//         "We accept all major credit cards (Visa, MasterCard, American Express), PayPal, and various digital payment methods. All transactions are processed securely through encrypted payment gateways.",
	//     },
	//     {
	//       id: 10,
	//       question: "How does billing work?",
	//       answer:
	//         "Subscriptions are billed monthly or annually depending on your chosen plan. You'll be charged on the same date each billing cycle. We send email notifications before each billing date, and you can cancel anytime from your account settings.",
	//     },
	//     {
	//       id: 11,
	//       question: "Can I get a refund?",
	//       answer:
	//         "We offer refunds within 7 days of purchase if you haven't accessed premium content. For technical issues or billing errors, contact our support team. Refunds are processed within 5-10 business days to your original payment method.",
	//     },
	//     {
	//       id: 12,
	//       question: "How do creator payouts work?",
	//       answer:
	//         "Creators are paid weekly via direct deposit, PayPal, or wire transfer. Minimum payout is $50. Earnings are calculated after a 7-day processing period to account for potential chargebacks or refunds.",
	//     },
	//   ],
	// },
	{
		id: 4,
		title: $_("faq.privacy.title"),
		icon: "icon-[ri--git-repository-private-line]",
		questions: [
			{
				id: 13,
				question: $_("faq.privacy.questions.0.question"),
				answer: $_("faq.privacy.questions.0.answer"),
			},
			{
				id: 14,
				question: $_("faq.privacy.questions.1.question"),
				answer: $_("faq.privacy.questions.1.answer"),
			},
			{
				id: 15,
				question: $_("faq.privacy.questions.2.question"),
				answer: $_("faq.privacy.questions.2.answer"),
			},
			{
				id: 16,
				question: $_("faq.privacy.questions.3.question"),
				answer: $_("faq.privacy.questions.3.answer"),
			},
		],
	},
	{
		id: 5,
		title: $_("faq.technical.title"),
		icon: "icon-[ri--settings-3-line]",
		questions: [
			{
				id: 17,
				question: $_("faq.technical.questions.0.question"),
				answer: $_("faq.technical.questions.0.answer"),
			},
			{
				id: 18,
				question: $_("faq.technical.questions.1.question"),
				answer: $_("faq.technical.questions.1.answer"),
			},
			{
				id: 19,
				question: $_("faq.technical.questions.2.question"),
				answer: $_("faq.technical.questions.2.answer"),
			},
			{
				id: 20,
				question: $_("faq.technical.questions.3.question"),
				answer: $_("faq.technical.questions.3.answer"),
			},
		],
	},
];

const allQuestions = faqCategories.flatMap((category) =>
	category.questions.map((q) => ({ ...q, categoryTitle: category.title })),
);

const filteredQuestions = $derived(() => {
	if (!searchQuery.trim()) return allQuestions;
	return allQuestions.filter(
		(q) =>
			q.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
			q.answer.toLowerCase().includes(searchQuery.toLowerCase()) ||
			q.categoryTitle.toLowerCase().includes(searchQuery.toLowerCase()),
	);
});

function toggleExpanded(id: number) {
	const newExpanded = new Set(expandedItems);
	if (newExpanded.has(id)) {
		newExpanded.delete(id);
	} else {
		newExpanded.add(id);
	}
	expandedItems = newExpanded;
}
</script>

<Meta title={$_("faq.title")} description={$_("faq.description")} />

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <PeonyBackground />

    <div class="container mx-auto py-20 relative px-4">
        <!-- Header -->
        <div class="text-center mb-16">
            <h1
                class="text-5xl md:text-6xl font-bold mb-8 bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent"
            >
                {$_("faq.title")}
            </h1>
            <p class="text-xl text-muted-foreground max-w-3xl mx-auto leading-relaxed">
                {$_("faq.description")}
            </p>
        </div>

        <!-- Search -->
        <div class="max-w-2xl mx-auto mb-12">
            <div class="relative">
                <span
                    class="icon-[ri--search-line] absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5"
                ></span>
                <Input
                    placeholder={$_("faq.search_placeholder")}
                    bind:value={searchQuery}
                    class="pl-12 h-14 text-lg bg-card/50 border-primary/20 focus:border-primary"
                />
            </div>
        </div>

        {#if searchQuery.trim()}
            <!-- Search Results -->
            <div class="max-w-4xl mx-auto">
                <h2 class="text-2xl font-bold mb-6">
                    {$_("faq.search_results", {
                        values: { count: filteredQuestions().length },
                    })}
                </h2>
                <div class="space-y-4">
                    {#each filteredQuestions() as question}
                        <Card
                            class="bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-lg shadow-primary/10"
                        >
                            <CardContent class="p-0">
                                <button
                                    onclick={() => toggleExpanded(question.id)}
                                    class="w-full p-6 text-left hover:bg-primary/5 transition-colors flex items-center justify-between"
                                >
                                    <div class="flex-1">
                                        <div class="text-sm text-primary font-medium mb-1">
                                            {question.categoryTitle}
                                        </div>
                                        <h3 class="font-semibold text-lg">{question.question}</h3>
                                    </div>
                                    {#if expandedItems.has(question.id)}
                                        <span
                                            class="icon-[ri--arrow-drop-up-line] w-7 h-7 text-muted-foreground flex-shrink-0 ml-4"
                                        ></span>
                                    {:else}
                                        <span
                                            class="icon-[ri--arrow-drop-down-line] w-7 h-7 text-muted-foreground flex-shrink-0 ml-4"
                                        ></span>
                                    {/if}
                                </button>
                                {#if expandedItems.has(question.id)}
                                    <div class="p-6">
                                        <p class="text-muted-foreground leading-relaxed">
                                            {question.answer}
                                        </p>
                                    </div>
                                {/if}
                            </CardContent>
                        </Card>
                    {/each}
                </div>
                {#if filteredQuestions.length === 0}
                    <div class="text-center py-12">
                        <p class="text-muted-foreground text-lg">{$_("faq.no_results")}</p>
                        <Button variant="outline" onclick={() => (searchQuery = "")} class="mt-4"
                            >{$_("faq.clear_search")}</Button
                        >
                    </div>
                {/if}
            </div>
        {:else}
            <!-- Category View -->
            <div class="max-w-6xl mx-auto">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    {#each faqCategories as category}
                        <Card
                            class="bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-lg shadow-primary/10"
                        >
                            <CardHeader class="pb-4">
                                <CardTitle class="flex items-center gap-3 text-xl">
                                    <div
                                        class="w-10 h-10 bg-gradient-to-br from-primary/20 to-accent/20 rounded-full flex items-center justify-center"
                                    >
                                        <span class={category.icon + " w-5 h-5 text-primary"}
                                        ></span>
                                    </div>
                                    {category.title}
                                </CardTitle>
                            </CardHeader>
                            <CardContent class="pt-0">
                                <div class="space-y-3">
                                    {#each category.questions as question}
                                        <div
                                            class="border border-border/50 rounded-lg overflow-hidden"
                                        >
                                            <button
                                                onclick={() => toggleExpanded(question.id)}
                                                class="w-full p-4 text-left hover:bg-primary/5 transition-colors flex items-center justify-between"
                                            >
                                                <h4 class="font-medium text-sm pr-4">
                                                    {question.question}
                                                </h4>
                                                {#if expandedItems.has(question.id)}
                                                    <span
                                                        class="icon-[ri--arrow-drop-up-line] w-6 h-6 text-muted-foreground flex-shrink-0"
                                                    ></span>
                                                {:else}
                                                    <span
                                                        class="icon-[ri--arrow-drop-down-line] w-6 h-6 text-muted-foreground flex-shrink-0"
                                                    ></span>
                                                {/if}
                                            </button>
                                            {#if expandedItems.has(question.id)}
                                                <div class="p-4 border-t border-border/50">
                                                    <p
                                                        class="text-muted-foreground text-sm leading-relaxed"
                                                    >
                                                        {question.answer}
                                                    </p>
                                                </div>
                                            {/if}
                                        </div>
                                    {/each}
                                </div>
                            </CardContent>
                        </Card>
                    {/each}
                </div>
            </div>
        {/if}

        <!-- Contact Support -->
        <div class="max-w-2xl mx-auto mt-16">
            <Card class="bg-gradient-to-br from-primary/10 to-accent/10 border-primary/20">
                <CardContent class="p-8 text-center">
                    <h3 class="text-2xl font-bold mb-4">{$_("faq.support.title")}</h3>
                    <p class="text-muted-foreground mb-6 leading-relaxed">
                        {$_("faq.support.description")}
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center">
                        <Button
                            class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                            href="mailto:{$_('faq.support.contact_email')}"
                            >{$_("faq.support.contact")}</Button
                        >
                        <!-- <Button
              variant="outline"
              class="border-primary/50 hover:bg-primary/10"
              >{$_("faq.support.live_chat")}</Button
            > -->
                    </div>
                </CardContent>
            </Card>
        </div>
    </div>
</div>
