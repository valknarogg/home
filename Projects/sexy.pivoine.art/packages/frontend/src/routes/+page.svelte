<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import { getAssetUrl } from "$lib/directus";
import Meta from "$lib/components/meta/meta.svelte";
import { formatVideoDuration } from "$lib/utils.js";

const { data } = $props();
</script>

<Meta title={$_('home.hero.title')} description={$_('home.hero.description')} />

<!-- Hero Section -->
<section
  class="relative min-h-screen flex items-center justify-center overflow-hidden"
>
  <!-- Background Gradient -->
  <div
    class="absolute inset-0 bg-gradient-to-br from-primary/20 via-accent/10 to-background"
  ></div>

  <!-- Content -->
  <div class="relative z-10 container mx-auto px-4 text-center">
    <div class="max-w-5xl mx-auto space-y-12">
      <h1
        class="text-6xl md:text-8xl font-bold bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent leading-tight mb-8"
      >
        {$_('home.hero.title')}
      </h1>

      <p
        class="text-xl md:text-2xl text-muted-foreground max-w-3xl mx-auto leading-relaxed"
      >
        {$_('home.hero.description')}
      </p>

      <div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
        <Button
          size="lg"
          class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90 text-lg px-8 py-6"
          href="/videos"
        >
          <span class="icon-[ri--play-large-fill]"></span>
          {$_('home.hero.cta_videos')}
        </Button>
        <Button
          variant="outline"
          size="lg"
          class="text-lg px-8 py-6 border-primary/50 hover:bg-primary/10"
          href="/models">{$_('home.hero.cta_models')}</Button
        >
      </div>
    </div>
  </div>

  <!-- Floating Elements -->
  <div
    class="absolute top-20 left-10 w-20 h-20 bg-primary/20 rounded-full blur-xl animate-pulse"
  ></div>
  <div
    class="absolute bottom-20 right-10 w-32 h-32 bg-accent/20 rounded-full blur-xl animate-pulse delay-1000"
  ></div>
</section>

<!-- Featured Models -->
<section class="py-20 bg-card/50">
  <div class="container mx-auto px-4">
    <div class="text-center mb-12">
      <h2 class="text-3xl md:text-4xl font-bold mb-4">
        {$_('home.featured_models.title')}
      </h2>
      <p class="text-muted-foreground text-lg">
        {$_('home.featured_models.description')}
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-lg mx-auto">
      {#each data.models as model}
        <Card
          class="p-0 group hover:shadow-2xl hover:shadow-primary/20 transition-all duration-300 hover:-translate-y-2 bg-gradient-to-br from-card to-card/50 border-primary/20"
        >
          <CardContent class="p-6 text-center">
            <div class="relative mb-4">
              <img
                src={getAssetUrl(model.avatar, 'mini')}
                alt={model.artist_name}
                class="w-24 h-24 rounded-full mx-auto object-cover ring-4 ring-primary/20 group-hover:ring-primary/40 transition-all"
              />
              <!-- <div
                class="absolute -bottom-2 -right-2 bg-primary text-primary-foreground rounded-full w-8 h-8 flex items-center justify-center text-sm font-bold"
              >
                <HeartIcon class="w-4 h-4 fill-current" />
              </div> -->
            </div>
            <h3 class="font-semibold text-lg mb-2">{model.artist_name}</h3>
            <!-- <div
              class="flex items-center justify-center gap-4 text-sm text-muted-foreground"
            >
              <div class="flex items-center gap-1">
                <StarIcon class="w-4 h-4 text-yellow-500 fill-current" />
                {model.rating}
              </div>
              <div>{model.videos} {$_("home.featured_models.videos")}</div>
            </div> -->
            <Button
              variant="ghost"
              size="sm"
              class="mt-4 w-full group-hover:bg-primary/10"
              href="/models/{model.slug}"
              >{$_('home.featured_models.view_profile')}</Button
            >
          </CardContent>
        </Card>
      {/each}
    </div>
  </div>
</section>

<!-- Featured Videos -->
<section class="py-20">
  <div class="container mx-auto px-4">
    <div class="text-center mb-12">
      <h2 class="text-3xl md:text-4xl font-bold mb-4">
        {$_('home.trending.title')}
      </h2>
      <!-- <p class="text-muted-foreground text-lg">Most watched romantic content</p> -->
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-6xl mx-auto">
      {#each data.videos as video}
        <Card
          class="p-0 group hover:shadow-2xl hover:shadow-accent/20 transition-all duration-300 hover:-translate-y-2 bg-gradient-to-br from-card to-card/50 border-accent/20 overflow-hidden"
        >
          <div class="relative">
            <img
              src={getAssetUrl(video.image, 'thumbnail')}
              alt={video.title}
              class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
            />
            <div
              class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent group-hover:scale-105 transition-transform duration-300"
            ></div>
            <div
              class="absolute bottom-2 left-2 text-white text-sm font-medium"
            >
              {formatVideoDuration(video.movie.duration)}
            </div>
            <!-- <div
              class="absolute top-2 right-2 bg-black/50 text-white text-xs px-2 py-1 rounded-full"
            >
              {video.views}
              {$_("home.trending.views")}
            </div> -->
            <div
              class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity"
            >
              <a
                class="w-16 h-16 bg-primary/90 rounded-full flex items-center justify-center"
                href="/videos/{video.slug}"
                aria-label={video.title}
              >
                <span class="icon-[ri--play-large-fill] w-8 h-8 text-white"
                ></span>
              </a>
            </div>
          </div>
          <CardContent class="px-4 pb-4 pt-0">
            <h3
              class="font-semibold mb-2 group-hover:text-primary transition-colors"
            >
              {video.title}
            </h3>

            <div class="flex items-center gap-2 text-sm text-muted-foreground">
              <span class="icon-[ri--fire-line] w-4 h-4"></span>
              {$_('home.trending.trending')}
            </div>
          </CardContent>
        </Card>
      {/each}
    </div>
  </div>
</section>

<!-- CTA Section -->
<section
  class="py-20 bg-gradient-to-r from-primary/10 via-accent/10 to-primary/10"
>
  <div class="container mx-auto px-4 text-center">
    <div class="max-w-3xl mx-auto space-y-8">
      <h2 class="text-3xl md:text-4xl font-bold">
        {$_('home.featured_models.join_community')}
      </h2>
      <p class="text-lg text-muted-foreground">
        {$_('home.featured_models.join_community_description')}
      </p>
      <div class="flex flex-col sm:flex-row gap-4 justify-center">
        <Button
          href="/signup"
          size="lg"
          class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90 text-lg px-8 py-6"
          >{$_('home.community.cta_join')}</Button
        >
        <Button
          variant="outline"
          size="lg"
          class="text-lg px-8 py-6 border-primary/50 hover:bg-primary/10"
          href="/magazine">{$_('home.community.cta_magazine')}</Button
        >
      </div>
    </div>
  </div>
</section>
