<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import { Input } from "$lib/components/ui/input";

import {
	Select,
	SelectContent,
	SelectItem,
	SelectTrigger,
} from "$lib/components/ui/select";

import TimeAgo from "javascript-time-ago";
import type { Article } from "$lib/types";
import { getAssetUrl } from "$lib/directus";
import { calcReadingTime } from "$lib/utils.js";
import Meta from "$lib/components/meta/meta.svelte";

let searchQuery = $state("");
let categoryFilter = $state("all");
let sortBy = $state("recent");

const timeAgo = new TimeAgo("en");
const { data }: { data: { articles: Article[] } } = $props();

const featuredArticle = data.articles.find((article) => article.featured);

const filteredArticles = $derived(() => {
	return data.articles
		.filter((article) => {
			const matchesSearch =
				article.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
				article.excerpt.toLowerCase().includes(searchQuery.toLowerCase()) ||
				article.author.first_name
					.toLowerCase()
					.includes(searchQuery.toLowerCase());
			const matchesCategory =
				categoryFilter === "all" || article.category === categoryFilter;
			return matchesSearch && matchesCategory;
		})
		.sort((a, b) => {
			if (sortBy === "recent")
				return (
					new Date(b.publish_date).getTime() -
					new Date(a.publish_date).getTime()
				);
			// if (sortBy === "popular")
			//   return (
			//     parseInt(b.views.replace(/[^\d]/g, "")) -
			//     parseInt(a.views.replace(/[^\d]/g, ""))
			//   );
			if (sortBy === "featured")
				return (b.featured ? 1 : 0) - (a.featured ? 1 : 0);
			return a.title.localeCompare(b.title);
		});
});
</script>

<Meta title={$_('magazine.title')} description={$_('magazine.description')} />

<div
  class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
  <!-- Global Plasma Background -->
  <div class="absolute inset-0 pointer-events-none">
    <div
      class="absolute top-40 left-1/4 w-80 h-80 bg-gradient-to-r from-primary/16 via-accent/20 to-primary/12 rounded-full blur-3xl animate-blob-slow"
    ></div>
    <div
      class="absolute bottom-40 right-1/4 w-96 h-96 bg-gradient-to-r from-accent/16 via-primary/20 to-accent/12 rounded-full blur-3xl animate-blob-slow animation-delay-5000"
    ></div>
    <div
      class="absolute top-1/3 right-1/3 w-64 h-64 bg-gradient-to-r from-primary/14 via-accent/18 to-primary/10 rounded-full blur-2xl animate-blob-reverse animation-delay-2500"
    ></div>
  </div>

  <section class="relative py-20 overflow-hidden">
    <div
      class="absolute inset-0 bg-gradient-to-br from-primary/10 via-accent/5 to-background"
    ></div>
    <div class="relative container mx-auto px-4 text-center">
      <div class="max-w-5xl mx-auto">
        <h1
          class="text-5xl md:text-7xl font-bold mb-8 bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent"
        >
          {$_('magazine.title')}
        </h1>
        <p
          class="text-xl md:text-2xl text-muted-foreground mb-10 leading-relaxed max-w-4xl mx-auto"
        >
          {$_('magazine.description')}
        </p>
        <!-- Filters -->
        <div class="flex flex-col md:flex-row gap-4 max-w-4xl mx-auto">
          <!-- Search -->
          <div class="relative flex-1">
            <span
              class="icon-[ri--search-line] absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground"
            ></span>
            <Input
              placeholder={$_('magazine.search_placeholder')}
              bind:value={searchQuery}
              class="pl-10 bg-background/50 border-primary/20 focus:border-primary"
            />
          </div>

          <!-- Category Filter -->
          <Select type="single" bind:value={categoryFilter}>
            <SelectTrigger
              class="w-full md:w-48 bg-background/50 border-primary/20 focus:border-primary"
            >
              <span class="icon-[ri--filter-line] w-4 h-4 mr-2"></span>
              {categoryFilter === 'all'
                ? $_('magazine.categories.all')
                : categoryFilter === 'photography'
                  ? $_('magazine.categories.photography')
                  : categoryFilter === 'production'
                    ? $_('magazine.categories.production')
                    : categoryFilter === 'interview'
                      ? $_('magazine.categories.interview')
                      : categoryFilter === 'psychology'
                        ? $_('magazine.categories.psychology')
                        : categoryFilter === 'trends'
                          ? $_('magazine.categories.trends')
                          : $_('magazine.categories.spotlight')}
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all"
                >{$_('magazine.categories.all')}</SelectItem
              >
              <SelectItem value="photography"
                >{$_('magazine.categories.photography')}</SelectItem
              >
              <SelectItem value="production"
                >{$_('magazine.categories.production')}</SelectItem
              >
              <SelectItem value="interview"
                >{$_('magazine.categories.interview')}</SelectItem
              >
              <SelectItem value="psychology"
                >{$_('magazine.categories.psychology')}</SelectItem
              >
              <SelectItem value="trends"
                >{$_('magazine.categories.trends')}</SelectItem
              >
              <SelectItem value="spotlight"
                >{$_('magazine.categories.spotlight')}</SelectItem
              >
            </SelectContent>
          </Select>

          <!-- Sort -->
          <Select type="single" bind:value={sortBy}>
            <SelectTrigger
              class="w-full md:w-48 bg-background/50 border-primary/20 focus:border-primary"
            >
              {sortBy === 'recent'
                ? $_('magazine.sort.recent')
                : sortBy === 'popular'
                  ? $_('magazine.sort.popular')
                  : sortBy === 'featured'
                    ? $_('magazine.sort.featured')
                    : $_('magazine.sort.name')}
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="recent"
                >{$_('magazine.sort.recent')}</SelectItem
              >
              <!-- <SelectItem value="popular"
              >{$_("magazine.sort.popular")}</SelectItem
            > -->
              <SelectItem value="featured"
                >{$_('magazine.sort.featured')}</SelectItem
              >
              <SelectItem value="name">{$_('magazine.sort.name')}</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>
    </div>
  </section>

  <div class="container mx-auto px-4 py-12">
    <!-- Featured Article -->
    {#if featuredArticle && categoryFilter === 'all' && !searchQuery}
      <Card
        class="py-0 mb-12 overflow-hidden bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-2xl shadow-primary/20"
      >
        <div class="grid grid-cols-1 lg:grid-cols-2">
          <div class="relative">
            <img
              src={getAssetUrl(featuredArticle.image, 'medium')}
              alt={featuredArticle.title}
              class="w-full h-96 object-cover"
            />
            <div
              class="absolute top-4 left-4 bg-gradient-to-r from-primary to-accent text-white px-3 py-1 rounded-full text-sm font-medium"
            >
              {$_('magazine.featured')}
            </div>
          </div>
          <CardContent class="p-8 flex flex-col justify-center">
            <div class="mb-4">
              <span
                class="text-sm text-primary font-medium capitalize bg-primary/10 px-2 py-1 rounded-full"
              >
                {featuredArticle.category}
              </span>
            </div>
            <h2
              class="text-2xl md:text-3xl font-bold mb-4 hover:text-primary transition-colors"
            >
              <button class="text-left">
                <a href="/article/{featuredArticle.slug}"
                  >{featuredArticle.title}</a
                >
              </button>
            </h2>
            <p class="text-muted-foreground mb-6 text-lg leading-relaxed">
              {featuredArticle.excerpt}
            </p>
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <img
                  src={getAssetUrl(featuredArticle.author.avatar, 'mini')}
                  alt={featuredArticle.author.first_name}
                  class="w-10 h-10 rounded-full object-cover"
                />
                <div>
                  <p class="font-medium">{featuredArticle.author.first_name}</p>
                  <div
                    class="flex items-center gap-3 text-sm text-muted-foreground"
                  >
                    <span
                      >{timeAgo.format(
                        new Date(featuredArticle.publish_date)
                      )}</span
                    >
                    <span>•</span>
                    <span
                      >{$_('magazine.read_time', {
                        values: {
                          time: calcReadingTime(featuredArticle.content)
                        }
                      })}
                    </span>
                  </div>
                </div>
              </div>
              <Button
                class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                href="/magazine/{featuredArticle.slug}"
                >{$_('magazine.read_article')}</Button
              >
            </div>
          </CardContent>
        </div>
      </Card>
    {/if}

    <!-- Articles Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      {#each filteredArticles() as article}
        <Card
          class="p-0 group hover:shadow-2xl hover:shadow-primary/25 transition-all duration-300 hover:-translate-y-3 bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-lg shadow-primary/10 overflow-hidden"
        >
          <div class="relative">
            <img
              src={getAssetUrl(article.image, 'preview')}
              alt={article.title}
              class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
            />
            <div
              class="absolute group-hover:scale-105 transition-transform inset-0 bg-gradient-to-t from-black/40 to-transparent duration-300"
            ></div>

            <!-- Category Badge -->
            <div
              class="absolute top-3 left-3 bg-primary/90 text-white text-xs px-2 py-1 rounded-full capitalize"
            >
              {article.category}
            </div>

            <!-- Featured Badge -->
            {#if article.featured}
              <div
                class="absolute top-3 right-3 bg-gradient-to-r from-primary to-accent text-white text-xs px-2 py-1 rounded-full"
              >
                {$_('magazine.featured')}
              </div>
            {/if}

            <!-- Views -->
            <!-- <div
              class="absolute bottom-3 right-3 text-white text-sm flex items-center gap-1"
            >
              <TrendingUpIcon class="w-4 h-4" />
              {article.views}
            </div> -->
          </div>

          <CardContent class="p-6">
            <div class="mb-4">
              <h3
                class="font-semibold text-lg mb-2 group-hover:text-primary transition-colors line-clamp-2"
              >
                <a href="/magazine/{article.slug}">{article.title}</a>
              </h3>
              <p
                class="text-muted-foreground text-sm line-clamp-3 leading-relaxed"
              >
                {article.excerpt}
              </p>
            </div>

            <!-- Tags -->
            <div class="flex flex-wrap gap-2 mb-4">
              {#each article.tags.slice(0, 3) as tag}
                <a
                  class="text-xs bg-primary/10 text-primary px-2 py-1 rounded-full"
                  href="/tags/{tag}"
                >
                  #{tag}
                </a>
              {/each}
            </div>

            <!-- Author & Meta -->
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <img
                  src={getAssetUrl(article.author.avatar, 'mini')}
                  alt={article.author.first_name}
                  class="w-8 h-8 rounded-full object-cover"
                />
                <div>
                  <p class="text-sm font-medium">{article.author.first_name}</p>
                  <div
                    class="flex items-center gap-2 text-xs text-muted-foreground"
                  >
                    <span class="icon-[ri--calendar-line] w-4 h-4"></span>
                    {timeAgo.format(new Date(article.publish_date))}
                  </div>
                </div>
              </div>
              <div class="text-xs text-muted-foreground">
                {$_('magazine.read_time', {
                  values: { time: calcReadingTime(article.content) }
                })}
              </div>
            </div>

            <!-- Read More Button -->
            <Button
              variant="outline"
              size="sm"
              class="w-full mt-4 border-primary/20 hover:bg-primary/10"
              href="/magazine/{article.slug}"
              >{$_('magazine.read_article')}</Button
            >
          </CardContent>
        </Card>
      {/each}
    </div>

    {#if filteredArticles().length === 0}
      <div class="text-center py-12">
        <p class="text-muted-foreground text-lg mb-4">
          {$_('magazine.no_results')}
        </p>
        <Button
          variant="outline"
          onclick={() => {
            searchQuery = '';
            categoryFilter = 'all';
          }}
          class="border-primary/20 hover:bg-primary/10"
        >
          {$_('magazine.clear_filters')}
        </Button>
      </div>
    {/if}
  </div>
</div>
