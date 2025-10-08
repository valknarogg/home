<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import { Card, CardContent } from "$lib/components/ui/card";
import "media-chrome";
import { getAssetUrl } from "$lib/directus";
import TimeAgo from "javascript-time-ago";
import { page } from "$app/state";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import Meta from "$lib/components/meta/meta.svelte";
import * as Alert from "$lib/components/ui/alert";
import Textarea from "$lib/components/ui/textarea/textarea.svelte";
import Avatar from "$lib/components/ui/avatar/avatar.svelte";
import { AvatarFallback, AvatarImage } from "$lib/components/ui/avatar";
import { formatVideoDuration, getUserInitials } from "$lib/utils";
import { invalidateAll } from "$app/navigation";
import { toast } from "svelte-sonner";
import { createCommentForVideo } from "$lib/services";
import NewsletterSignup from "$lib/components/newsletter-signup/newsletter-signup-widget.svelte";
import SharingPopupButton from "$lib/components/sharing-popup/sharing-popup-button.svelte";

const timeAgo = new TimeAgo("en");
let isLiked = $state(false);
let isBookmarked = $state(false);
let newComment = $state("");
let showComments = $state(true);
let isCommentLoading = $state(false);
let isCommentError = $state(false);
let commentError = $state();

const relatedVideos = [
	{
		id: 2,
		title: "Sunset Dreams",
		thumbnail: "/placeholder.svg?size=wide",
		duration: "8:45",
		views: "1.8M",
		model: "Luna Belle",
	},
	{
		id: 3,
		title: "Intimate Moments",
		thumbnail: "/placeholder.svg?size=wide",
		duration: "15:22",
		views: "3.2M",
		model: "Aria Divine",
	},
	{
		id: 4,
		title: "Morning Light",
		thumbnail: "/placeholder.svg?size=wide",
		duration: "10:15",
		views: "956K",
		model: "Maya Starlight",
	},
	{
		id: 5,
		title: "Passionate Dance",
		thumbnail: "/placeholder.svg?size=wide",
		duration: "7:33",
		views: "1.4M",
		model: "Zara Moon",
	},
];

function handleLike() {
	isLiked = !isLiked;
}

function handleBookmark() {
	isBookmarked = !isBookmarked;
}

async function handleComment(e: Event) {
	e.preventDefault();
	try {
		isCommentLoading = true;
		isCommentError = false;
		commentError = "";
		await createCommentForVideo(data.video.id, newComment);
		toast.success($_("videos.toast_comment"));
		invalidateAll();
		newComment = "";
		showComments = true;
	} catch (err: any) {
		commentError = err.message;
		isCommentError = true;
	} finally {
		isCommentLoading = false;
	}
}

let showPlayer = $state(false);

const { data } = $props();
</script>

<Meta
  title={data.video.title}
  description={data.video.description}
  image={getAssetUrl(data.video.image, 'medium')!}
/>

<div
  class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
  <PeonyBackground />
  <div class="container mx-auto px-4 py-8">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- Main Video Section -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Video Player -->
        <Card
          class="p-0 overflow-hidden bg-gradient-to-br from-card to-card/50"
        >
          <div class="relative aspect-video bg-black">
            {#if showPlayer}
              <media-controller>
                <video
                  slot="media"
                  src={getAssetUrl(data.video.movie.id)}
                  poster={getAssetUrl(data.video.image, 'preview')}
                  autoplay
                  class="inline"
                >
                  <track kind="captions" />
                </video>
                <media-control-bar>
                  <media-play-button></media-play-button>
                  <media-mute-button></media-mute-button>
                  <media-volume-range></media-volume-range>
                  <media-time-range></media-time-range>
                  <media-pip-button></media-pip-button>
                  <media-fullscreen-button></media-fullscreen-button>
                </media-control-bar>
              </media-controller>
            {:else}
              <img
                src={getAssetUrl(data.video.image, 'medium')}
                alt={data.video.title}
                class="w-full h-full object-cover"
              />
              <div
                class="absolute inset-0 bg-black/20 flex items-center justify-center"
              >
                <button
                  class="cursor-pointer w-20 h-20 bg-primary/90 hover:bg-primary rounded-full flex flex-col items-center justify-center transition-colors shadow-2xl"
                  aria-label={data.video.title}
                  data-umami-event="play-video"
                  data-umami-event-title={data.video.title}
                  data-umami-event-id={data.video.movie.id}
                  onclick={() => (showPlayer = true)}
                >
                  <span class="icon-[ri--play-large-fill] w-10 h-10 text-white"
                  ></span>
                </button>
              </div>
              <div
                class="absolute bottom-4 left-4 bg-black/70 text-white px-3 py-1 rounded font-medium"
              >
                {formatVideoDuration(data.video.movie.duration)}
              </div>
              {#if data.video.premium}
                <div
                  class="absolute top-4 left-4 bg-gradient-to-r from-primary to-accent text-white px-3 py-1 rounded-full font-medium"
                >
                  {$_('videos.premium')}
                </div>
              {/if}
            {/if}
          </div>
        </Card>

        <!-- Video Info -->
        <div class="space-y-4">
          <div>
            <h1 class="text-2xl md:text-3xl font-bold mb-2">
              {data.video.title}
            </h1>
            <div
              class="flex flex-wrap items-center gap-4 text-sm text-muted-foreground"
            >
              <!-- <div class="flex items-center gap-1">
                <EyeIcon class="w-4 h-4" />
                {data.video.views} views
              </div> -->
              <div class="flex items-center gap-1">
                <span class="icon-[ri--calendar-line] w-4 h-4"></span>
                {timeAgo.format(new Date(data.video.upload_date))}
              </div>
              <!-- <span class="bg-primary/10 text-primary px-2 py-1 rounded-full">
                {data.video.category}
              </span> -->
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex flex-wrap gap-3">
            <!-- <Button
              variant={isLiked ? "default" : "outline"}
              onclick={handleLike}
              class="flex items-center gap-2 {isLiked
                ? 'bg-gradient-to-r from-primary to-accent'
                : 'border-primary/20 hover:bg-primary/10'}"
            >
              <ThumbsUpIcon class="w-4 h-4 {isLiked ? 'fill-current' : ''}" />
              {data.video.likes}
            </Button> -->
            <SharingPopupButton
              content={{
                title: data.video.title,
                description: data.video.description,
                url: page.url.href,
                type: 'video' as const
              }}
            />
            <!-- <Button
              variant={isBookmarked ? "default" : "outline"}
              onclick={handleBookmark}
              class="flex items-center gap-2 {isBookmarked
                ? 'bg-gradient-to-r from-primary to-accent'
                : 'border-primary/20 hover:bg-primary/10'}"
            >
              <BookmarkIcon
                class="w-4 h-4 {isBookmarked ? 'fill-current' : ''}"
              />
              Save
            </Button> -->
          </div>

          <!-- Model Info -->
          <div class="grid grid-cols-1 gap-4">
            {#each data.video.models as model}
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-4">
                  <a href={`/models/${model.slug}`}>
                    <img
                      src={getAssetUrl(model.avatar as string, 'thumbnail')}
                      alt={model.artist_name}
                      class="w-12 h-12 rounded-full object-cover ring-2 ring-primary/20 hover:ring-primary/40 transition-all"
                    />
                  </a>
                  <div>
                    <a
                      href={`/models/${model.slug}`}
                      class="font-semibold hover:text-primary transition-colors flex items-center gap-2"
                    >
                      {model.artist_name}
                      <div
                        class="w-4 h-4 bg-primary rounded-full flex items-center justify-center"
                      >
                        <svg
                          class="w-2.5 h-2.5 text-white"
                          fill="currentColor"
                          viewBox="0 0 20 20"
                        >
                          <path
                            fill-rule="evenodd"
                            d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                            clip-rule="evenodd"
                          />
                        </svg>
                      </div>
                    </a>
                    <!-- <p class="text-sm text-muted-foreground">
                      {data.video.model.subscribers} subscribers
                    </p> -->
                  </div>
                </div>
                <!-- <Button
                  class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                  >Subscribe</Button
                > -->
              </div>
            {/each}
          </div>

          <!-- Description -->
          <Card class="p-0 bg-card/50">
            <CardContent class="p-4">
              <p class="text-muted-foreground mb-4">{data.video.description}</p>
              <div class="flex flex-wrap gap-2">
                {#each data.video.tags as tag}
                  <a
                    class="text-xs bg-primary/10 text-primary px-2 py-1 rounded-full"
                    href="/tags/{tag}"
                  >
                    #{tag}
                  </a>
                {/each}
              </div>
            </CardContent>
          </Card>

          <!-- Comments Section -->
          <Card class="p-0 bg-card/50">
            <CardContent class="p-4">
              <div class="flex items-center justify-between mb-4">
                <h3 class="font-semibold flex items-center gap-2">
                  <span class="icon-[ri--message-line] w-5 h-5"></span>
                  {$_('videos.comments', {
                    values: {
                      comments: data.comments.length
                    }
                  })}
                </h3>
                {#if data.comments.length > 0}
                  <Button
                    variant="link"
                    size="sm"
                    class="cursor-pointer"
                    onclick={() => (showComments = !showComments)}
                  >
                    {showComments ? $_('videos.hide') : $_('videos.show')}
                  </Button>
                {/if}
              </div>

              <!-- Add Comment -->
              {#if data.authStatus.authenticated}
                <div class="flex gap-3 mb-6">
                  <Avatar
                    class="h-8 w-8 ring-2 ring-accent/20 transition-all duration-200"
                  >
                    <AvatarImage
                      src={getAssetUrl(data.authStatus.user!.avatar.id, 'mini')}
                      alt={data.authStatus.user!.artist_name}
                    />
                    <AvatarFallback
                      class="bg-gradient-to-br from-primary to-accent text-primary-foreground text-xs font-semibold transition-all duration-200"
                    >
                      {getUserInitials(data.authStatus.user!.artist_name)}
                    </AvatarFallback>
                  </Avatar>
                  <form class="flex-1 space-y-4" onsubmit={handleComment}>
                    <div class="space-y-2">
                      <Textarea
                        placeholder={$_('videos.add_comment_placeholder')}
                        bind:value={newComment}
                        class="bg-background/50 border-primary/20 focus:border-primary resize-none"
                        rows={2}
                      ></Textarea>
                    </div>
                    {#if isCommentError}
                      <div class="grid w-full max-w-xl items-start gap-4">
                        <Alert.Root variant="destructive">
                          <Alert.Title class="items-center flex"
                            ><span
                              class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                            ></span>{$_('videos.error')}</Alert.Title
                          >
                          <Alert.Description>{commentError}</Alert.Description>
                        </Alert.Root>
                      </div>
                    {/if}
                    <div class="flex justify-end space">
                      <Button
                        size="sm"
                        class="cursor-pointer bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                        disabled={!newComment.trim() || isCommentLoading}
                        type="submit"
                      >
                        {#if isCommentLoading}
                          <div
                            class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"
                          ></div>
                          {$_('videos.commenting')}
                        {:else}
                          {$_('videos.comment')}
                        {/if}
                      </Button>
                    </div>
                  </form>
                </div>
              {/if}

              {#if showComments}
                <!-- Comments List -->
                <div class="space-y-4">
                  {#each data.comments as comment}
                    <div class="flex gap-3">
                      <Avatar
                        class="h-8 w-8 ring-2 ring-accent/20 transition-all duration-200"
                      >
                        <AvatarImage
                          src={getAssetUrl(
                            comment.user_created.avatar as string,
                            'mini'
                          )}
                          alt={comment.user_created.artist_name}
                        />
                        <AvatarFallback
                          class="bg-gradient-to-br from-primary to-accent text-primary-foreground text-xs font-semibold transition-all duration-200"
                        >
                          {getUserInitials(data.authStatus.user!.artist_name)}
                        </AvatarFallback>
                      </Avatar>
                      <div class="flex-1">
                        <div class="flex items-center gap-2 mb-1">
                          <span class="font-medium text-sm"
                            >{comment.user_created.artist_name}</span
                          >
                          <span class="text-xs text-muted-foreground"
                            >{timeAgo.format(
                              new Date(comment.date_created)
                            )}</span
                          >
                        </div>
                        <p class="text-sm mb-2">{comment.comment}</p>
                        <div
                          class="flex items-center gap-4 text-xs text-muted-foreground"
                        >
                          <!-- <button
                            class="flex items-center gap-1 hover:text-primary transition-colors"
                          >
                            <ThumbsUpIcon class="w-3 h-3" />
                            {comment.likes}
                          </button> -->
                          <!-- {#if comment.replies > 0}
                            <button
                              class="hover:text-primary transition-colors"
                            >
                              {comment.replies} replies
                            </button>
                          {/if} -->
                        </div>
                      </div>
                    </div>
                  {/each}
                </div>
              {/if}
            </CardContent>
          </Card>
        </div>
      </div>

      <!-- Sidebar -->
      <div class="space-y-6">
        <!-- Related Videos -->
        <!-- <Card class="bg-card/50">
          <CardContent class="p-4">
            <h3 class="font-semibold mb-4">Related Videos</h3>
            <div class="space-y-4">
              {#each relatedVideos as relatedVideo}
                <button
                  onclick={() => onNavigate('video')}
                  class="flex gap-3 w-full text-left hover:bg-primary/5 p-2 rounded-lg transition-colors"
                >
                  <div class="relative">
                <img
                      src={relatedData.video.thumbnail}
                      alt={relatedData.video.title}
                      class="w-24 h-16 object-cover rounded"
                    />
                    <div
                      class="absolute bottom-1 right-1 bg-black/70 text-white text-xs px-1 rounded"
                    >
                      {relatedData.video.duration}
                    </div>
                  </div>
                  <div class="flex-1 min-w-0">
                    <h4 class="font-medium text-sm line-clamp-2 mb-1">
                      {relatedData.video.title}
                    </h4>
                    <p class="text-xs text-muted-foreground">
                      {relatedData.video.model}
                    </p>
                    <p class="text-xs text-muted-foreground">
                      {relatedData.video.views} views
                    </p>
                  </div>
                </button>
              {/each}
            </div>
          </CardContent>
        </Card> -->

        <NewsletterSignup />

        <!-- Back to Videos -->
        <Button
          variant="outline"
          href="/videos"
          class="w-full border-primary/20 hover:bg-primary/10"
          ><span class="icon-[ri--arrow-left-long-line] w-4 h-4 mr-1"
          ></span>{$_('videos.back')}</Button
        >
      </div>
    </div>
  </div>
</div>
