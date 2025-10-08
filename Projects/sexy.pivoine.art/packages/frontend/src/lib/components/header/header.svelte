<script lang="ts">
import { _ } from "svelte-i18n";
import { page } from "$app/state";
import PeonyIcon from "$lib/components/icon/peony-icon.svelte";
import { Button } from "$lib/components/ui/button";
import type { AuthStatus } from "$lib/types";
import { logout } from "$lib/services";
import { goto } from "$app/navigation";
import { getAssetUrl, isModel } from "$lib/directus";
import LogoutButton from "../logout-button/logout-button.svelte";
import Separator from "../ui/separator/separator.svelte";
import { Avatar, AvatarFallback, AvatarImage } from "$lib/components/ui/avatar";
import { getUserInitials } from "$lib/utils";
import BurgerMenuButton from "../burger-menu-button/burger-menu-button.svelte";
import Girls from "../girls/girls.svelte";
import Logo from "../logo/logo.svelte";

interface Props {
	authStatus: AuthStatus;
}

let { authStatus }: Props = $props();

let isMobileMenuOpen = $state(false);

const navLinks = [
	{ name: $_("header.home"), href: "/" },
	{ name: $_("header.models"), href: "/models" },
	{ name: $_("header.videos"), href: "/videos" },
	{ name: $_("header.magazine"), href: "/magazine" },
	{ name: $_("header.about"), href: "/about" },
];

async function handleLogout() {
	closeMenu();
	await logout();
	goto("/login", { invalidateAll: true });
}

function closeMenu() {
	isMobileMenuOpen = false;
}

function isActiveLink(link: any) {
	return (
		(page.url.pathname === "/" && link === navLinks[0]) ||
		(page.url.pathname.startsWith(link.href) && link !== navLinks[0])
	);
}
</script>

<header
  class="sticky top-0 z-50 w-full bg-gradient-to-br from-card/85 via-card/90 to-card/80 backdrop-blur-xl shadow-2xl shadow-primary/20"
>
  <div class="container mx-auto px-4">
    <div class="flex items-center justify-evenly h-16">
      <!-- Logo -->
      <a
        href="/"
        class="flex w-full items-center gap-3 hover:scale-105 transition-all duration-300"
      >
          <Logo hideName={true} />
      </a>

      <!-- Desktop Navigation -->
      <nav class="hidden w-full lg:flex items-center justify-center gap-8">
        {#each navLinks as link}
          <a
            href={link.href}
            class={`text-sm hover:text-foreground transition-colors duration-200 font-medium relative group ${
              isActiveLink(link) ? 'text-foreground' : 'text-foreground/85'
            }`}
          >
            {link.name}
            <span
              class={`absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-primary to-accent transition-all duration-300 ${isActiveLink(link) ? 'w-full' : 'group-hover:w-full'}`}
            ></span>
          </a>
        {/each}
      </nav>

      <!-- Desktop Login Button -->
      {#if authStatus.authenticated}
        <div class="w-full flex items-center justify-end">
          <div class="flex items-center gap-2 rounded-full bg-muted/30 p-1">
            <!-- Notifications -->
            <!-- <Button variant="ghost" size="sm" class="relative h-9 w-9 rounded-full p-0 hover:bg-background/80">
						<BellIcon class="h-4 w-4" />
						<Badge class="absolute -right-1 -top-1 h-5 w-5 rounded-full bg-gradient-to-r from-primary to-accent p-0 text-xs text-primary-foreground">3</Badge>
						<span class="sr-only">Notifications</span>
					</Button> -->

            <!-- <Separator orientation="vertical" class="mx-1 h-6 bg-border/50" /> -->

            <!-- User Actions -->
            <Button
              variant="link"
              size="icon"
              class={`hidden sm:flex h-9 w-9 rounded-full p-0 relative text-foreground/80 group ${isActiveLink({ href: '/me' }) ? 'text-foreground' : 'hover:text-foreground'}`}
              href="/me"
              title={$_('header.dashboard')}
            >
              <span class="icon-[ri--dashboard-2-line] h-4 w-4"></span>
              <span
                class={`absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-primary to-accent transition-all duration-300 ${isActiveLink({ href: '/me' }) ? 'w-full' : 'group-hover:w-full'}`}
              ></span>
              <span class="sr-only">{$_('header.dashboard')}</span>
            </Button>

            <Button
              variant="link"
              size="icon"
              class={`hidden sm:flex h-9 w-9 rounded-full p-0 relative text-foreground/80 group ${isActiveLink({ href: '/play' }) ? 'text-foreground' : 'hover:text-foreground'}`}
              href="/play"
              title={$_('header.play')}
            >
              <span class="icon-[ri--rocket-line] h-4 w-4"></span>
              <span
                class={`absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-primary to-accent transition-all duration-300 ${isActiveLink({ href: '/play' }) ? 'w-full' : 'group-hover:w-full'}`}
              ></span>
              <span class="sr-only">{$_('header.play')}</span>
            </Button>

            <Separator orientation="vertical" class="hidden md:flex mx-1 h-6 bg-border/50" />

            <!-- Slide Logout Button -->

            <LogoutButton
              user={{
                name: authStatus.user!.artist_name,
                avatar: getAssetUrl(authStatus.user!.avatar?.id, 'mini')!,
                email: authStatus.user!.email
              }}
              onLogout={handleLogout}
            />
          </div>
        </div>
      {:else}
        <div class="flex w-full items-center justify-end gap-4">
          <Button variant="outline" class="font-medium" href="/login"
            >{$_('header.login')}</Button
          >
          <Button
            href="/signup"
            class="bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90 font-medium"
            >{$_('header.signup')}</Button
          >
        </div>
      {/if}
      <BurgerMenuButton
        label={$_('header.navigation')}
        bind:isMobileMenuOpen
        onclick={() => (isMobileMenuOpen = !isMobileMenuOpen)}
      />
    </div>
  </div>
  <!-- Mobile Navigation -->
  <div
    class={`border-t border-border/20 bg-background/95 bg-gradient-to-br from-primary to-accent backdrop-blur-xl max-h-[calc(100vh-4rem)] overflow-y-auto shadow-xl/30 transition-all duration-250 ${isMobileMenuOpen ? 'opacity-100' : 'opacity-0'}`}
  >
    {#if isMobileMenuOpen}
      <div class="container mx-auto grid grid-cols-1 lg:grid-cols-3">
        <div class="hidden lg:flex col-span-2">
          <Girls />
        </div>
        <div class="py-6 px-4 space-y-6 lg:col-start-3 border-t border-border/20 bg-background/95 ">
          <!-- User Profile Card -->
          {#if authStatus.authenticated}
            <div
              class="relative overflow-hidden rounded-2xl border border-border/50 bg-gradient-to-br from-card to-card/50 p-4 backdrop-blur-sm"
            >
              <div
                class="absolute inset-0 bg-gradient-to-br from-primary/5 to-accent/5"
              ></div>
              <div class="relative flex items-center gap-4">
                <Avatar class="h-14 w-14 ring-2 ring-primary/30">
                  <AvatarImage
                    src={getAssetUrl(authStatus.user!.avatar?.id, 'mini')}
                    alt={authStatus.user!.artist_name}
                  />
                  <AvatarFallback
                    class="bg-gradient-to-br from-primary to-accent text-primary-foreground font-semibold"
                  >
                    {getUserInitials(authStatus.user!.artist_name)}
                  </AvatarFallback>
                </Avatar>
                <div class="flex flex-1 flex-col gap-1">
                  <p class="text-base font-semibold text-foreground">
                    {authStatus.user!.artist_name}
                  </p>
                  <p class="text-sm text-muted-foreground">
                    {authStatus.user!.email}
                  </p>
                  <div class="flex items-center gap-2 mt-1">
                    <div class="h-2 w-2 rounded-full bg-green-500"></div>
                    <span class="text-xs text-muted-foreground">Online</span>
                  </div>
                </div>
                <!-- Notifications Badge -->
                <!-- <Button
                  variant="ghost"
                  size="sm"
                  class="relative h-10 w-10 rounded-full p-0"
                >
                  <BellIcon class="h-4 w-4" />
                  <Badge
                    class="absolute -right-1 -top-1 h-5 w-5 rounded-full bg-gradient-to-r from-primary to-accent p-0 text-xs text-primary-foreground"
                    >3</Badge
                  >
                </Button> -->
              </div>
            </div>
          {/if}
          <!-- Navigation Cards -->
          <div class="space-y-3">
            <h3
              class="px-1 text-xs font-semibold text-muted-foreground uppercase tracking-wider"
            >
              {$_('header.navigation')}
            </h3>
            <div class="grid gap-2">
              {#each navLinks as link}
                <a
                  href={link.href}
                  class="flex items-center justify-between rounded-xl border border-border/50 bg-card/50 p-4 backdrop-blur-sm transition-all hover:bg-card hover:border-primary/20 {isActiveLink(
                    link
                  )
                    ? 'border-primary/30 bg-primary/5'
                    : ''}"
                  onclick={() => (isMobileMenuOpen = false)}
                >
                  <span class="font-medium text-foreground">{link.name}</span>
                  <div class="flex items-center gap-2">
                    <!-- {#if isActiveLink(link)}
                      <div class="h-2 w-2 rounded-full bg-primary"></div>
                    {/if} -->
                    <span
                      class="icon-[ri--arrow-drop-right-line] h-6 w-6 text-muted-foreground"
                    ></span>
                  </div>
                </a>
              {/each}
            </div>
          </div>

          <!-- Account Actions -->
          <div class="space-y-3">
            <h3
              class="px-1 text-xs font-semibold text-muted-foreground uppercase tracking-wider"
            >
              {$_('header.account')}
            </h3>

            <div class="grid gap-2">
              {#if authStatus.authenticated}
                <a
                  class={`flex items-center gap-4 rounded-xl border border-border/50 bg-card/50 p-4 text-left backdrop-blur-sm transition-all group hover:bg-card hover:border-primary/20 ${isActiveLink({ href: '/me' }) ? 'border-primary/30 bg-primary/5' : ''}`}
                  href="/me"
                  onclick={closeMenu}
                >
                  <div
                    class={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-muted to-muted/50 transition-all group-hover:bg-card group-hover:from-primary/10 group-hover:to-accent/10`}
                  >
                    <span
                      class="icon-[ri--dashboard-2-line] h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors"
                    ></span>
                  </div>
                  <div class="flex flex-1 flex-col gap-1">
                    <div class="flex items-center gap-2">
                      <span class="font-medium text-foreground"
                        >{$_('header.dashboard')}</span
                      >
                    </div>
                    <span class="text-sm text-muted-foreground"
                      >{$_('header.dashboard_hint')}</span
                    >
                  </div>
                  <span
                    class="icon-[ri--arrow-drop-right-line] h-6 w-6 text-muted-foreground transition-all"
                  ></span>
                </a>

                <a
                  class={`flex items-center gap-4 rounded-xl border border-border/50 bg-card/50 p-4 text-left backdrop-blur-sm transition-all group hover:bg-card hover:border-primary/20 ${isActiveLink({ href: '/play' }) ? 'border-primary/30 bg-primary/5' : ''}`}
                  href="/play"
                  onclick={closeMenu}
                >
                  <div
                    class={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-muted to-muted/50 transition-all group-hover:bg-card group-hover:from-primary/10 group-hover:to-accent/10`}
                  >
                    <span
                      class="icon-[ri--rocket-line] h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors"
                    ></span>
                  </div>
                  <div class="flex flex-1 flex-col gap-1">
                    <div class="flex items-center gap-2">
                      <span class="font-medium text-foreground"
                        >{$_('header.play')}</span
                      >
                    </div>
                    <span class="text-sm text-muted-foreground"
                      >{$_('header.play_hint')}</span
                    >
                  </div>
                  <span
                    class="icon-[ri--arrow-drop-right-line] h-6 w-6 text-muted-foreground transition-all"
                  ></span>
                </a>
              {:else}
                <a
                  class={`flex items-center gap-4 rounded-xl border border-border/50 bg-card/50 p-4 text-left backdrop-blur-sm transition-all group hover:bg-card hover:border-primary/20 ${isActiveLink({ href: '/login' }) ? 'border-primary/30 bg-primary/5' : ''}`}
                  href="/login"
                  onclick={closeMenu}
                >
                  <div
                    class={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-muted to-muted/50 transition-all group-hover:bg-card group-hover:from-primary/10 group-hover:to-accent/10`}
                  >
                    <span
                      class="icon-[ri--login-circle-line] h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors"
                    ></span>
                  </div>
                  <div class="flex flex-1 flex-col gap-1">
                    <div class="flex items-center gap-2">
                      <span class="font-medium text-foreground"
                        >{$_('header.login')}</span
                      >
                    </div>
                    <span class="text-sm text-muted-foreground"
                      >{$_('header.login_hint')}</span
                    >
                  </div>
                  <span
                    class="icon-[ri--arrow-drop-right-line] h-6 w-6 text-muted-foreground transition-all"
                  ></span>
                </a>

                <a
                  class={`flex items-center gap-4 rounded-xl border border-border/50 bg-card/50 p-4 text-left backdrop-blur-sm transition-all group hover:bg-card hover:border-primary/20 ${isActiveLink({ href: '/signup' }) ? 'border-primary/30 bg-primary/5' : ''}`}
                  href="/signup"
                  onclick={closeMenu}
                >
                  <div
                    class={`flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-muted to-muted/50 transition-all group-hover:bg-card group-hover:from-primary/10 group-hover:to-accent/10`}
                  >
                    <span
                      class="icon-[ri--heart-add-2-line] h-4 w-4 text-muted-foreground group-hover:text-foreground transition-colors"
                    ></span>
                  </div>
                  <div class="flex flex-1 flex-col gap-1">
                    <div class="flex items-center gap-2">
                      <span class="font-medium text-foreground"
                        >{$_('header.signup')}</span
                      >
                    </div>
                    <span class="text-sm text-muted-foreground"
                      >{$_('header.signup_hint')}</span
                    >
                  </div>
                  <span
                    class="icon-[ri--arrow-drop-right-line] h-6 w-6 text-muted-foreground transition-all"
                  ></span>
                </a>
              {/if}
            </div>
          </div>

          {#if authStatus.authenticated}
            <!-- Logout Button -->
            <button
              class="cursor-pointer flex w-full items-center gap-4 rounded-xl border border-destructive/20 bg-destructive/5 p-4 text-left backdrop-blur-sm transition-all hover:bg-destructive/10 hover:border-destructive/30 group"
              onclick={handleLogout}
            >
              <div
                class="flex h-10 w-10 items-center justify-center rounded-xl bg-destructive/10 group-hover:bg-destructive/20 transition-all"
              >
                <span
                  class="icon-[ri--logout-circle-r-line] h-4 w-4 text-destructive"
                ></span>
              </div>
              <div class="flex flex-1 flex-col gap-1">
                <span class="font-medium text-foreground"
                  >{$_('header.logout')}</span
                >
                <span class="text-sm text-muted-foreground"
                  >{$_('header.logout_hint')}</span
                >
              </div>
            </button>
          {/if}
        </div>
      </div>
    {/if}
  </div>
</header>
