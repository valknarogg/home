<script lang="ts">
import { _, locale } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import {
	Tabs,
	TabsContent,
	TabsList,
	TabsTrigger,
} from "$lib/components/ui/tabs";
import { getAssetUrl } from "$lib/directus";
import Meta from "$lib/components/meta/meta.svelte";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import SharingPopupButton from "$lib/components/sharing-popup/sharing-popup-button.svelte";
import { page } from "$app/state";
import ImageViewer from "$lib/components/image-viewer/image-viewer.svelte";
import { formatVideoDuration } from "$lib/utils.js";

let activeTab = $state("videos");

const { data } = $props();

let images = $derived(
	data.model.photos.map((p) => ({
		...p,
		url: getAssetUrl(p.id),
		thumbnail: getAssetUrl(p.id, "thumbnail"),
	})),
);
</script>

<Meta
  title={data.model.artist_name}
  description={data.model.description}
  image={getAssetUrl(data.model.avatar, 'medium')!}
/>

<div
  class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
  <PeonyBackground />

  <!-- Cover Section -->
  <div class="relative h-64 md:h-80 overflow-hidden bg-gradient-to-br from-primary to-accent">
    {#if data.model.banner}
      <img
        src={getAssetUrl(data.model.banner.id, "banner")}
        alt={$_(data.model.artist_name)}
        class="w-full h-full object-cover"
      />
      <div
        class="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent"
      ></div>
    {/if}
    <!-- Back Button -->
    <Button
      variant="ghost"
      class="absolute top-4 left-4 bg-black/50 hover:bg-black/70 text-white"
      href="/models"
      ><span class="icon-[ri--arrow-left-long-line] w-4 h-4 mr-1"></span>{$_(
        'models.back'
      )}</Button
    >
  </div>

  <!-- Profile Header -->
  <div class="container mx-auto px-4 -mt-20 relative z-10">
    <div
      class="bg-card/90 backdrop-blur-sm rounded-2xl border border-border/50 p-6 shadow-2xl"
    >
      <div class="flex flex-col md:flex-row gap-6">
        <!-- Profile Image -->
        <div class="relative">
          <img
            src={getAssetUrl(data.model.avatar, 'thumbnail')}
            alt="${data.model.artist_name}"
            class="w-32 h-32 rounded-2xl object-cover ring-4 ring-primary/20"
          />
          <!-- {#if data.model.isOnline}
            <div
              class="absolute -bottom-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full flex items-center gap-1"
            >
              <div class="w-2 h-2 bg-white rounded-full animate-pulse"></div>
              Online
            </div>
          {/if} -->
        </div>

        <!-- Profile Info -->
        <div class="flex-1">
          <div
            class="flex flex-col md:flex-row md:items-start md:justify-between gap-4"
          >
            <div>
              <h1 class="text-3xl font-bold mb-2">{data.model.artist_name}</h1>
              <div class="flex items-center gap-4 text-muted-foreground mb-3">
                <!-- <div class="flex items-center gap-1">
                  <StarIcon class="w-4 h-4 text-yellow-500 fill-current" />
                  {data.model.rating} rating
                </div>
                <div class="flex items-center gap-1">
                  <MapPinIcon class="w-4 h-4" />
                  {data.model.location}
                </div> -->
                <div class="flex items-center gap-1">
                  <span class="icon-[ri--calendar-line] w-4 h-4"></span>
                  {$_('models.joined', {
                    values: {
                      join_date: new Date(
                        data.model.join_date
                      ).toLocaleDateString($locale!, {
                        day: 'numeric',
                        month: 'long',
                        year: 'numeric'
                      })
                    }
                  })}
                </div>
              </div>
              <div class="prose text-muted-foreground mb-4 max-w-2xl">
                {data.model.description}
              </div>

              <!-- Tags -->
              <div class="flex flex-wrap gap-2">
                {#each data.model.tags as tag}
                  <a
                    class="text-xs bg-primary/10 text-primary px-3 py-1 rounded-full"
                    href="/tags/{tag}"
                  >
                    #{tag}
                  </a>
                {/each}
              </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col gap-3 min-w-48">
              <!--
            <Button
                onclick={() => (isFollowing = !isFollowing)}
                class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
              >
                <HeartIcon
                  class="w-4 h-4 mr-2 {isFollowing ? 'fill-current' : ''}"
                />
                {isFollowing ? "Following" : "Follow"}
              </Button>
              <div class="grid grid-cols-2 gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  class="border-primary/20 hover:bg-primary/10"
                >
                  <MessageCircleIcon class="w-4 h-4 mr-1" />
                  Message
                </Button>
          -->
              <SharingPopupButton
                content={{
                  title: data.model.artist_name,
                  description: data.model.description,
                  url: page.url,
                  type: 'model'
                }}
              />
            </div>
          </div>
        </div>
      </div>

      <!-- Stats -->
      <div
        class="grid grid-cols-2 md:grid-cols-5 gap-4 mt-6 pt-6 border-t border-border/50"
      >
        <!-- <div class="text-center">
          <div class="text-2xl font-bold text-primary">
            {data.model.subscribers}
          </div>
          <div class="text-sm text-muted-foreground">Followers</div>
        </div> -->
        <div class="text-center">
          <div class="text-2xl font-bold text-primary">
            {data.videos.length}
          </div>
          <div class="text-sm text-muted-foreground">{$_('models.videos')}</div>
        </div>
        <!-- <div class="text-center">
          <div class="text-2xl font-bold text-primary">
            {data.model.stats.totalViews}
          </div>
          <div class="text-sm text-muted-foreground">Total Views</div>
        </div> -->
        <!-- <div class="text-center">
          <div class="text-2xl font-bold text-primary">
            {data.model.stats.likes}
          </div>
          <div class="text-sm text-muted-foreground">Likes</div>
        </div> -->
        <div class="text-center">
          <div class="text-2xl font-bold text-primary">
            {data.commentsCount}
          </div>
          <div class="text-sm text-muted-foreground">
            {$_('models.comments')}
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Content Tabs -->
  <div class="container mx-auto px-4 py-8">
    <Tabs bind:value={activeTab} class="w-full">
      <TabsList class="grid w-full grid-cols-2 max-w-md mx-auto mb-8">
        <TabsTrigger value="videos" class="flex items-center gap-2">
          <span class="icon-[ri--play-large-fill] w-4 h-4"></span>
          {$_('models.videos')}
        </TabsTrigger>
        <TabsTrigger value="photos" class="flex items-center gap-2">
          <span class="icon-[ri--camera-fill] w-4 h-4"></span>
          {$_('models.photos')}
        </TabsTrigger>
      </TabsList>

      <TabsContent value="videos">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {#each data.videos as video}
            <Card
              class="p-0 group hover:shadow-2xl hover:shadow-primary/20 transition-all duration-300 hover:-translate-y-2 bg-gradient-to-br from-card to-card/50 border-primary/20 overflow-hidden"
            >
              <div class="relative">
                <img
                  src={getAssetUrl(video.image, 'preview')}
                  alt={video.title}
                  class="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <div
                  class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent transition-transform group-hover:scale-105 duration-300"
                ></div>
                <div
                  class="absolute bottom-2 left-2 text-white text-sm font-medium"
                >
                  {formatVideoDuration(video.movie.duration)}
                </div>
                <!-- <div
                  class="absolute top-2 right-2 bg-black/50 text-white text-xs px-2 py-1 rounded-full"
                >
                  {video.views} views
                </div> -->
                <a
                  class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all group-hover:scale-105 duration-300"
                  href={`/videos/${video.slug}`}
                  aria-label={video.title}
                >
                  <div
                    class="w-16 h-16 bg-primary/90 rounded-full flex flex-col items-center justify-center shadow-2xl"
                  >
                    <span class="icon-[ri--play-large-fill] w-8 h-8 text-white"
                    ></span>
                  </div>
                </a>
              </div>
              <CardContent class="px-4 pb-4 pt-0">
                <h3
                  class="font-semibold mb-2 group-hover:text-primary transition-colors"
                >
                  {video.title}
                </h3>
                <!-- <div
                  class="flex items-center justify-between text-sm text-muted-foreground"
                >
                  <span>{video.views} views</span>
                  <div class="flex items-center gap-1">
                    <HeartIcon class="w-4 h-4" />
                    {video.likes}
                  </div>
                </div> -->
              </CardContent>
            </Card>
          {/each}
        </div>
      </TabsContent>

       <TabsContent value="photos">
        <ImageViewer {images} />
      </TabsContent>
      
    </Tabs>
  </div>
</div>
