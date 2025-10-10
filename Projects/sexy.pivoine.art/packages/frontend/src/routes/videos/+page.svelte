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
import { getAssetUrl } from "$lib/directus";
import Meta from "$lib/components/meta/meta.svelte";
import TimeAgo from "javascript-time-ago";
import { formatVideoDuration } from "$lib/utils";

const timeAgo = new TimeAgo("en");

let searchQuery = $state("");
let sortBy = $state("trending");
let categoryFilter = $state("all");
let durationFilter = $state("all");

const { data } = $props();

const filteredVideos = $derived(() => {
	return data.videos
		.filter((video) => {
			const matchesSearch = video.title
				.toLowerCase()
				.includes(searchQuery.toLowerCase());
			//  ||
			// video.model.toLowerCase().includes(searchQuery.toLowerCase());
			const matchesCategory = categoryFilter === "all";
			const matchesDuration =
				durationFilter === "all" ||
				(durationFilter === "short" && video.movie.duration < 10 * 60) ||
				(durationFilter === "medium" &&
					video.movie.duration >= 10 * 60 &&
					video.movie.duration < 20 * 60) ||
				(durationFilter === "long" && video.movie.duration >= 20 * 60);
			return matchesSearch && matchesCategory && matchesDuration;
		})
		.sort((a, b) => {
			// if (sortBy === "trending")
			//   return (
			//     parseInt(b.views.replace(/[^\d]/g, "")) -
			//     parseInt(a.views.replace(/[^\d]/g, ""))
			//   );
			if (sortBy === "recent")
				return (
					new Date(b.upload_date).getTime() - new Date(a.upload_date).getTime()
				);
			// if (sortBy === "popular")
			//   return (
			//     parseInt(b.likes.replace(/[^\d]/g, "")) -
			//     parseInt(a.likes.replace(/[^\d]/g, ""))
			//   );
			if (sortBy === "duration") return b.movie.duration - a.movie.duration;
			return a.title.localeCompare(b.title);
		});
});
</script>

<Meta title={$_('videos.title')} description={$_('videos.description')} />

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
          {$_('videos.title')}
        </h1>
        <p
          class="text-xl md:text-2xl text-muted-foreground mb-10 leading-relaxed max-w-4xl mx-auto"
        >
          {$_('videos.description')}
        </p>

        <!-- Filters -->
        <div class="flex flex-col lg:flex-row gap-4 max-w-6xl mx-auto">
          <!-- Search -->
          <div class="relative flex-1">
            <span
              class="icon-[ri--search-line] absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground"
            ></span>
            <Input
              placeholder={$_('videos.search_placeholder')}
              bind:value={searchQuery}
              class="pl-10 bg-background/50 border-primary/20 focus:border-primary"
            />
          </div>

          <!-- Category Filter -->
          <Select type="single" bind:value={categoryFilter}>
            <SelectTrigger
              class="w-full lg:w-48 bg-background/50 border-primary/20 focus:border-primary"
            >
              <span class="icon-[ri--filter-line] w-4 h-4 mr-2"></span>
              {categoryFilter === 'all'
                ? $_('videos.categories.all')
                : categoryFilter === 'romantic'
                  ? $_('videos.categories.romantic')
                  : categoryFilter === 'artistic'
                    ? $_('videos.categories.artistic')
                    : categoryFilter === 'intimate'
                      ? $_('videos.categories.intimate')
                      : $_('videos.categories.performance')}
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">{$_('videos.categories.all')}</SelectItem>
              <SelectItem value="romantic"
                >{$_('videos.categories.romantic')}</SelectItem
              >
              <SelectItem value="artistic"
                >{$_('videos.categories.artistic')}</SelectItem
              >
              <SelectItem value="intimate"
                >{$_('videos.categories.intimate')}</SelectItem
              >
              <SelectItem value="performance"
                >{$_('videos.categories.performance')}</SelectItem
              >
            </SelectContent>
          </Select>

          <!-- Duration Filter -->
          <Select type="single" bind:value={durationFilter}>
            <SelectTrigger
              class="w-full lg:w-48 bg-background/50 border-primary/20 focus:border-primary"
            >
              <span class="icon-[ri--timer-2-line] w-4 h-4 mr-2"></span>
              {durationFilter === 'all'
                ? $_('videos.duration.all')
                : durationFilter === 'short'
                  ? $_('videos.duration.short')
                  : durationFilter === 'medium'
                    ? $_('videos.duration.medium')
                    : $_('videos.duration.long')}
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">{$_('videos.duration.all')}</SelectItem>
              <SelectItem value="short"
                >{$_('videos.duration.short')}</SelectItem
              >
              <SelectItem value="medium"
                >{$_('videos.duration.medium')}</SelectItem
              >
              <SelectItem value="long">{$_('videos.duration.long')}</SelectItem>
            </SelectContent>
          </Select>

          <!-- Sort -->
          <Select type="single" bind:value={sortBy}>
            <SelectTrigger
              class="w-full lg:w-48 bg-background/50 border-primary/20 focus:border-primary"
            >
              {sortBy === 'trending'
                ? $_('videos.sort.trending')
                : sortBy === 'recent'
                  ? $_('videos.sort.recent')
                  : sortBy === 'popular'
                    ? $_('videos.sort.popular')
                    : sortBy === 'duration'
                      ? $_('videos.sort.duration')
                      : $_('videos.sort.name')}
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="trending"
                >{$_('videos.sort.trending')}</SelectItem
              >
              <SelectItem value="recent">{$_('videos.sort.recent')}</SelectItem>
              <SelectItem value="popular"
                >{$_('videos.sort.popular')}</SelectItem
              >
              <SelectItem value="duration"
                >{$_('videos.sort.duration')}</SelectItem
              >
              <SelectItem value="name">{$_('videos.sort.name')}</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>
    </div>
  </section>
  <!-- Videos Grid -->
  <div class="container mx-auto px-4 py-12">
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      {#each filteredVideos() as video}
        <Card
          class="p-0 group hover:shadow-2xl hover:shadow-primary/25 transition-all duration-500 hover:-translate-y-3 bg-gradient-to-br from-card/90 via-card/95 to-card/85 backdrop-blur-xl shadow-lg shadow-primary/10 overflow-hidden"
        >
          <div class="relative">
            <img
              src={getAssetUrl(video.image, 'preview')}
              alt={video.title}
              class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
            />

            <!-- Overlay Gradient -->
            <div
              class="absolute inset-0 group-hover:scale-105 bg-gradient-to-t from-black/60 via-transparent to-black/20 duration-300"
            ></div>

            <!-- Duration -->
            <div
              class="absolute bottom-3 left-3 bg-black/70 text-white text-sm px-2 py-1 rounded font-medium"
            >
              {formatVideoDuration(video.movie.duration)}
            </div>

            <!-- Premium Badge -->
            {#if video.premium}
              <div
                class="absolute top-3 left-3 bg-gradient-to-r from-primary to-accent text-white text-xs px-2 py-1 rounded-full font-medium"
              >
                {$_('videos.premium')}
              </div>
            {/if}

            <!-- Views -->
            <!-- <div
              class="absolute top-3 right-3 bg-black/70 text-white text-xs px-2 py-1 rounded-full flex items-center gap-1"
            >
              <EyeIcon class="w-3 h-3" />
              {video.views}
            </div> -->

            <!-- Play Overlay -->
            <a
              class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity"
              href={`/videos/${video.slug}`}
              aria-label={$_('videos.watch')}
            >
              <div
                class="w-16 h-16 bg-primary/90 rounded-full flex flex-col items-center justify-center shadow-2xl"
              >
                <span class="icon-[ri--play-large-fill] w-8 h-8 text-white"
                ></span>
              </div>
            </a>

            <!-- Model Info -->
            <!-- <div class="absolute bottom-3 right-3 text-white text-sm">
              <button
                onclick={() => onNavigate("model")}
                class="hover:text-primary transition-colors"
              >
                {video.model}
              </button>
            </div> -->
          </div>

          <CardContent class="p-6">
            <div class="mb-3">
              <h3
                class="font-semibold text-lg mb-2 group-hover:text-primary transition-colors line-clamp-2"
              >
                {video.title}
              </h3>
              <p class="text-sm text-muted-foreground">
                {timeAgo.format(new Date(video.upload_date))}
              </p>
            </div>

            <!-- Stats -->
            <div
              class="flex items-center justify-between text-sm text-muted-foreground mb-4"
            >
              <!-- <div class="flex items-center gap-4">
                <div class="flex items-center gap-1">
                  <EyeIcon class="w-4 h-4" />
                  {video.views}
                </div>
                <div class="flex items-center gap-1">
                  <HeartIcon class="w-4 h-4" />
                  {video.likes}
                </div>
              </div> -->
              <!-- <span
                                class="capitalize bg-primary/10 text-primary px-2 py-1 rounded-full text-xs"
                            >
                                {video.category}
                            </span> -->
            </div>

            <!-- Action Buttons -->
            <div class="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                class="flex-1 border-primary/20 hover:bg-primary/10"
                href={`/videos/${video.slug}`}
              >
                <span class="icon-[ri--play-large-fill] w-4 h-4 mr-2"></span>
                {$_('videos.watch')}
              </Button>
              <!-- <Button
                variant="ghost"
                size="sm"
                class="px-3 hover:bg-primary/10"
              >
                <HeartIcon class="w-4 h-4" />
              </Button> -->
            </div>
          </CardContent>
        </Card>
      {/each}
    </div>

    {#if filteredVideos().length === 0}
      <div class="text-center py-12">
        <p class="text-muted-foreground text-lg mb-4">
          {$_('videos.no_results')}
        </p>
        <Button
          variant="outline"
          onclick={() => {
            searchQuery = '';
            categoryFilter = 'all';
            durationFilter = 'all';
          }}
          class="border-primary/20 hover:bg-primary/10"
        >
          {$_('videos.clear_filters')}
        </Button>
      </div>
    {/if}
  </div>
</div>
