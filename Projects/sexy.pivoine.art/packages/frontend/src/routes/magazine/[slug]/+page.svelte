<script lang="ts">
import { _ } from "svelte-i18n";
import { page } from "$app/state";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import { calcReadingTime } from "$lib/utils";
import TimeAgo from "javascript-time-ago";
import { getAssetUrl } from "$lib/directus";
import SharingPopup from "$lib/components/sharing-popup/sharing-popup.svelte";
import Meta from "$lib/components/meta/meta.svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import NewsletterSignup from "$lib/components/newsletter-signup/newsletter-signup-widget.svelte";
import SharingPopupButton from "$lib/components/sharing-popup/sharing-popup-button.svelte";

const { data } = $props();

const timeAgo = new TimeAgo("en");
</script>

<Meta
    title={data.article.title}
    description={data.article.excerpt}
    image={getAssetUrl(data.article.image, "medium")!}
/>

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <PeonyBackground />

    <div class="container mx-auto px-4 py-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Main Article -->
            <article class="lg:col-span-2">
                <!-- Header -->
                <div class="mb-8">
                    <Button variant="ghost" href="/magazine" class="mb-6 hover:bg-primary/10"
                        ><span class="icon-[ri--arrow-left-long-line] w-4 h-4 mr-1"></span>{$_(
                            "magazine.back",
                        )}</Button
                    >

                    <!-- Category Badge -->
                    <div class="mb-4">
                        <span
                            class="bg-primary/10 text-primary px-3 py-1 rounded-full text-sm font-medium capitalize"
                        >
                            {data.article.category}
                        </span>
                    </div>

                    <!-- Title -->
                    <h1 class="text-3xl md:text-4xl lg:text-5xl font-bold mb-4 leading-tight">
                        {data.article.title}
                    </h1>

                    <!-- Subtitle -->
                    <p class="text-xl text-muted-foreground mb-6 leading-relaxed">
                        {data.article.excerpt}
                    </p>

                    <!-- Meta Information -->
                    <div
                        class="flex flex-wrap items-center gap-6 text-sm text-muted-foreground mb-6"
                    >
                        <div class="flex items-center gap-2">
                            <span class="icon-[ri--calendar-line] w-4 h-4"></span>
                            {timeAgo.format(new Date(data.article.publish_date))}
                        </div>
                        <div class="flex items-center gap-2">
                            <span class="icon-[ri--timer-2-line] w-4 h-4"></span>
                            {$_("magazine.read_time", {
                                values: {
                                    time: calcReadingTime(data.article.content),
                                },
                            })}
                        </div>
                        <!-- <div class="flex items-center gap-2">
              <UserIcon class="w-4 h-4" />
              {data.article.views} views
            </div> -->
                    </div>

                    <!-- Action Buttons -->
                    <!-- <div class="flex flex-wrap gap-3 mb-8">
            <Button
              variant={isLiked ? "default" : "outline"}
              size="sm"
              onclick={handleLike}
              class="flex items-center gap-2 {isLiked
                ? 'bg-gradient-to-r from-primary to-accent'
                : 'border-primary/20 hover:bg-primary/10'}"
            >
              <HeartIcon class="w-4 h-4 {isLiked ? 'fill-current' : ''}" />
              {data.article.likes}
            </Button> -->
                    <SharingPopupButton content={{
                            title: data.article.title,
                            description: data.article.excerpt,
                            url: page.url.href,
                            type: "article" as const,
                        }} />
  
                </div>

                <!-- Featured Image -->
                <div class="mb-8">
                    <img
                        src={getAssetUrl(data.article.image, "medium")}
                        alt={data.article.title}
                        class="w-full h-64 md:h-96 object-cover rounded-2xl shadow-2xl"
                    />
                </div>

                <!-- Article Content -->
                <Card class="p-0 mb-8 bg-card/50">
                    <CardContent class="p-8">
                        <div
                            class="prose prose-lg max-w-none prose-headings:text-foreground prose-p:text-muted-foreground prose-strong:text-foreground prose-ul:text-muted-foreground"
                        >
                            {@html data.article.content}
                        </div>
                    </CardContent>
                </Card>

                <!-- Tags -->
                <div class="mb-8">
                    <div class="flex items-center gap-2 mb-4">
                        <span class="icon-[ri--price-tag-3-line] w-5 h-5 text-primary"></span>
                        <span class="font-semibold">Tags</span>
                    </div>
                    <div class="flex flex-wrap gap-2">
                        {#each data.article.tags as tag}
                            <a class="bg-primary/10 text-primary px-3 py-1 rounded-full text-sm" href="/tags/{tag}">
                                #{tag}
                            </a>
                        {/each}
                    </div>
                </div>

                <!-- Author Bio -->
                <Card class="p-0 bg-gradient-to-r from-card/50 to-card">
                    <CardContent class="p-6">
                        <div class="flex items-start gap-4">
                            <img
                                src={getAssetUrl(data.article.author.avatar, "mini")}
                                alt={data.article.author.first_name}
                                class="w-16 h-16 rounded-full object-cover ring-2 ring-primary/20"
                            />
                            <div class="flex-1">
                                <h3 class="font-semibold text-lg mb-2">
                                    About {data.article.author.first_name}
                                </h3>
                                {#if data.article.author.description}
                                    <p class="text-muted-foreground mb-4">
                                        {data.article.author.description}
                                    </p>
                                {/if}
                                {#if data.article.author.website}
                                    <div class="flex gap-4 text-sm">
                                        <a
                                            href={"https://" + data.article.author.website}
                                            class="text-primary hover:underline"
                                        >
                                            {data.article.author.website}
                                        </a>
                                        <!-- <a href="https://{data.article.author.social.website}" class="text-primary hover:underline">
                    {data.article.author.social.website}
                  </a> -->
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </CardContent>
                </Card>
            </article>

            <!-- Sidebar -->
            <aside class="space-y-6">
                <!-- Related Articles -->
                <!--
        <Card class="bg-card/50">
          <CardContent class="p-6">
            <h3 class="font-semibold mb-4 flex items-center gap-2">
              <MessageCircleIcon class="w-5 h-5 text-primary" />
              Related Articles
            </h3>
            <div class="space-y-4">
              {#each relatedArticles as related}
                <button
                  onclick={() => onNavigate("article")}
                  class="flex gap-3 w-full text-left hover:bg-primary/5 p-3 rounded-lg transition-colors"
                >
                  <img
                    src={related.image}
                    alt={related.title}
                    class="w-20 h-16 object-cover rounded"
                  />
                  <div class="flex-1 min-w-0">
                    <h4 class="font-medium text-sm line-clamp-2 mb-2">
                      {related.title}
                    </h4>
                    <div
                      class="flex items-center gap-2 text-xs text-muted-foreground"
                    >
                      <span>{related.author}</span>
                      <span>•</span>
                      <span>{related.readTime}</span>
                    </div>
                  </div>
                </button>
              {/each}
            </div>
          </CardContent>
        </Card>
        -->

                <NewsletterSignup email={data.authStatus.user?.email}/>

                <!-- Back to Magazine -->
                <Button
                    variant="outline"
                    class="w-full border-primary/20 hover:bg-primary/10"
                    href="/magazine"
                    ><span class="icon-[ri--arrow-left-long-line] w-4 h-4 mr-1"></span>{$_(
                        "magazine.back",
                    )}</Button
                >
            </aside>
        </div>
    </div>
</div>
