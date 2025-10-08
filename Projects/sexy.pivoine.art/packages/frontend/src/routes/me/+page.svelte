<script lang="ts">
import { _ } from "svelte-i18n";
import { Button } from "$lib/components/ui/button";
import {
	Card,
	CardContent,
	CardDescription,
	CardHeader,
	CardTitle,
} from "$lib/components/ui/card";
import {
	Tabs,
	TabsContent,
	TabsList,
	TabsTrigger,
} from "$lib/components/ui/tabs";
import { Input } from "$lib/components/ui/input";
import { Label } from "$lib/components/ui/label";
import PeonyBackground from "$lib/components/background/peony-background.svelte";
import { onMount } from "svelte";
import { goto, invalidateAll } from "$app/navigation";
import { getAssetUrl, isModel } from "$lib/directus";
import * as Alert from "$lib/components/ui/alert";
import { toast } from "svelte-sonner";
import { removeFile, updateProfile, uploadFile } from "$lib/services";
import { Textarea } from "$lib/components/ui/textarea";
import Meta from "$lib/components/meta/meta.svelte";
import { TagsInput } from "$lib/components/ui/tags-input";
import {
	displaySize,
	FileDropZone,
	MEGABYTE,
} from "$lib/components/ui/file-drop-zone";
import * as Avatar from "$lib/components/ui/avatar";

const { data } = $props();

let activeTab = $state("settings");

let firstName = $state(data.authStatus.user!.first_name);
let lastName = $state(data.authStatus.user!.last_name);
let artistName = $state(data.authStatus.user!.artist_name);
let description = $state(data.authStatus.user!.description);
let tags = $state(data.authStatus.user!.tags);

let email = $state(data.authStatus.user!.email);
let password = $state("");
let confirmPassword = $state("");

let showPassword = $state(false);
let showConfirmPassword = $state(false);

let isProfileLoading = $state(false);
let isProfileError = $state(false);
let profileError = $state("");

let isSecurityLoading = $state(false);
let isSecurityError = $state(false);
let securityError = $state("");

async function handleProfileSubmit(e: Event) {
	e.preventDefault();
	try {
		isProfileLoading = true;
		isProfileError = false;
		profileError = "";

		let avatarId = undefined;

		if (!avatar?.id && data.authStatus.user!.avatar?.id) {
			await removeFile(data.authStatus.user!.avatar.id);
		}

		if (avatar?.file) {
			const formData = new FormData();
			formData.append(
				"folder",
				data.folders.find((f) => f.name === "avatars")!.id,
			);
			formData.append("file", avatar.file!);
			const result = await uploadFile(formData);
			avatarId = result.id;
		}

		await updateProfile({
			first_name: firstName,
			last_name: lastName,
			artist_name: artistName,
			description,
			tags,
			avatar: avatarId,
		});
		toast.success($_("me.settings.toast_update"));
		invalidateAll();
	} catch (err: any) {
		profileError = err.message;
		isProfileError = true;
	} finally {
		isProfileLoading = false;
	}
}

async function handleSecuritySubmit(e: Event) {
	e.preventDefault();
	try {
		if (password !== confirmPassword) {
			throw new Error($_("me.settings.password_error"));
		}
		isSecurityLoading = true;
		isSecurityError = false;
		securityError = "";
		await updateProfile({
			email,
			password,
		});
		toast.success($_("me.settings.toast_update"));
		invalidateAll();
		password = confirmPassword = "";
	} catch (err: any) {
		securityError = err.message;
		isSecurityError = true;
	} finally {
		isSecurityLoading = false;
	}
}

let avatar = $state<{
	id?: string;
	url: string;
	name: string;
	size: number;
	file?: File;
}>();

async function handleFilesUpload(files: File[]) {
	const file = files[0];
	avatar = {
		name: file.name,
		size: file.size,
		url: URL.createObjectURL(file),
		file,
	};
}

async function handleAvatarRemove() {
	if (avatar!.id) {
		avatar = undefined;
	} else {
		setExistingAvatar();
	}
}

function setExistingAvatar() {
	if (data.authStatus.user!.avatar) {
		avatar = {
			id: data.authStatus.user!.avatar.id,
			url: getAssetUrl(data.authStatus.user!.avatar.id, "mini")!,
			name: data.authStatus.user!.artist_name,
			size: data.authStatus.user!.avatar.filesize,
		};
	} else {
		avatar = undefined;
	}
}

onMount(() => {
	if (data.authStatus.authenticated) {
		setExistingAvatar();
		return;
	}
	goto("/login");
});
</script>

<Meta
    title={$_("me.title")}
    description={$_("me.welcome", {
        values: { name: data.authStatus.user!.artist_name },
    })}
/>

<div
    class="relative min-h-screen bg-gradient-to-br from-background via-primary/5 to-accent/5 overflow-hidden"
>
    <PeonyBackground />
    <div class="container mx-auto px-4 py-8">
        <!-- Header -->
        <div class="mb-8">
            <div class="flex items-center justify-between mb-8">
                <div>
                    <h1
                        class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-primary via-accent to-primary bg-clip-text text-transparent mb-3"
                    >
                        {$_("me.title")}
                    </h1>
                    <p class="text-lg text-muted-foreground">
                        {$_("me.welcome", {
                            values: { name: data.authStatus.user!.artist_name },
                        })}
                    </p>
                </div>
                {#if isModel(data.authStatus.user!)}
                    <Button
                        href={`/models/${data.authStatus.user!.slug}`}
                        variant="outline"
                        class="border-primary/20 hover:bg-primary/10"
                        >{$_("me.view_profile")}</Button
                    >
                {/if}
            </div>
        </div>

        <!-- Dashboard Tabs -->
        <Tabs bind:value={activeTab} class="w-full">
            <TabsList class="grid w-full grid-cols-4 max-w-2xl mb-8">
                <TabsTrigger value="settings" class="flex items-center gap-2">
                    <span class="icon-[ri--settings-4-line] w-4 h-4"></span>
                    {$_("me.settings.title")}
                </TabsTrigger>
            </TabsList>

            <!-- Settings Tab -->
            <TabsContent value="settings" class="space-y-6">
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Profile Settings -->
                    <Card class="bg-card/50 border-primary/20">
                        <CardHeader>
                            <CardTitle>{$_("me.settings.profile_title")}</CardTitle>
                            <CardDescription>{$_("me.settings.profile_subtitle")}</CardDescription>
                        </CardHeader>
                        <CardContent class="space-y-4">
                            <form onsubmit={handleProfileSubmit} class="space-y-4">
                                <div class="space-y-2">
                                    <Label for="avatar">{$_("me.settings.avatar")}</Label>
                                    <FileDropZone
                                        id="avatar"
                                        fileCount={0}
                                        maxFiles={1}
                                        maxFileSize={2 * MEGABYTE}
                                        onUpload={handleFilesUpload}
                                        accept="image/*"
                                    />
                                    {#if avatar}
                                        <div class="flex place-items-center justify-between gap-2">
                                            <div class="flex place-items-center gap-2">
                                                <div class="relative size-9 overflow-clip">
                                                    <img
                                                        src={avatar.url}
                                                        alt={avatar.name}
                                                        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 overflow-clip"
                                                    />
                                                </div>
                                                <div class="flex flex-col">
                                                    <span>{avatar.name}</span>
                                                    <span class="text-muted-foreground text-xs"
                                                        >{displaySize(avatar.size)}</span
                                                    >
                                                </div>
                                            </div>
                                            <div class="gap-2">
                                                <Button
                                                    variant="outline"
                                                    size="icon"
                                                    onclick={handleAvatarRemove}
                                                    class="cursor-pointer"
                                                    ><span class="icon-[ri--delete-bin-line]"
                                                    ></span></Button
                                                >
                                            </div>
                                        </div>
                                    {/if}
                                </div>
                                <!-- Name Fields -->
                                <div class="grid grid-cols-2 gap-4">
                                    <div class="space-y-2">
                                        <Label for="firstName">{$_("me.settings.first_name")}</Label
                                        >
                                        <Input
                                            id="firstName"
                                            placeholder={$_("me.settings.first_name_placeholder")}
                                            bind:value={firstName}
                                            required
                                            class="bg-background/50 border-primary/20 focus:border-primary"
                                        />
                                    </div>
                                    <div class="space-y-2">
                                        <Label for="lastName">{$_("me.settings.last_name")}</Label>
                                        <Input
                                            id="lastName"
                                            placeholder={$_("me.settings.last_name_placeholder")}
                                            bind:value={lastName}
                                            required
                                            class="bg-background/50 border-primary/20 focus:border-primary"
                                        />
                                    </div>
                                </div>
                                <div class="space-y-2">
                                    <Label for="artistName">{$_("me.settings.artist_name")}</Label>
                                    <Input
                                        id="artistName"
                                        placeholder={$_("me.settings.artist_name_placeholder")}
                                        bind:value={artistName}
                                        required
                                        class="bg-background/50 border-primary/20 focus:border-primary"
                                    />
                                </div>
                                <div class="space-y-2">
                                    <Label for="description">{$_("me.settings.description")}</Label>
                                    <Textarea
                                        id="description"
                                        bind:value={description}
                                        placeholder={$_("me.settings.description_placeholder")}
                                        class="bg-background/50 border-primary/20 focus:border-primary"
                                        rows={3}
                                    />
                                </div>
                                <div class="space-y-2">
                                    <Label for="tags">{$_("me.settings.tags")}</Label>
                                    <TagsInput
                                        id="tags"
                                        bind:value={tags}
                                        placeholder={$_("me.settings.tags_placeholder")}
                                        class="bg-background/50 border-primary/20 focus:border-primary"
                                    />
                                </div>
                                {#if isProfileError}
                                    <div class="grid w-full items-start gap-4">
                                        <Alert.Root variant="destructive">
                                            <Alert.Title class="items-center flex"
                                                ><span
                                                    class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                                                ></span>{$_("me.settings.error")}</Alert.Title
                                            >
                                            <Alert.Description>{profileError}</Alert.Description>
                                        </Alert.Root>
                                    </div>
                                {/if}
                                <Button
                                    type="submit"
                                    class="cursor-pointer w-full bg-gradient-to-r from-primary to-accent hover:from-primary/90 hover:to-accent/90"
                                    disabled={isProfileLoading}
                                >
                                    {#if isProfileLoading}
                                        <div
                                            class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"
                                        ></div>
                                        {$_("me.settings.updating_profile")}
                                    {:else}
                                        {$_("me.settings.update_profile")}
                                    {/if}
                                </Button>
                            </form>
                        </CardContent>
                    </Card>

                    <!-- Privacy Settings -->
                    <Card class="bg-card/50 border-primary/20">
                        <CardHeader>
                            <CardTitle>{$_("me.settings.privacy_title")}</CardTitle>
                            <CardDescription>{$_("me.settings.privacy_subtitle")}</CardDescription>
                        </CardHeader>
                        <CardContent class="space-y-4">
                            <form onsubmit={handleSecuritySubmit} class="space-y-4">
                                <!-- Email -->
                                <div class="space-y-2">
                                    <Label for="email">{$_("me.settings.email")}</Label>
                                    <Input
                                        id="email"
                                        type="email"
                                        placeholder={$_("me.settings.email_placeholder")}
                                        bind:value={email}
                                        required
                                        class="bg-background/50 border-primary/20 focus:border-primary"
                                    />
                                </div>

                                <!-- Password -->
                                <div class="space-y-2">
                                    <Label for="password">{$_("me.settings.password")}</Label>
                                    <div class="relative">
                                        <Input
                                            id="password"
                                            type={showPassword ? "text" : "password"}
                                            placeholder={$_("me.settings.password_placeholder")}
                                            bind:value={password}
                                            required
                                            class="bg-background/50 border-primary/20 focus:border-primary pr-10"
                                        />
                                        <button
                                            type="button"
                                            onclick={() => (showPassword = !showPassword)}
                                            class="cursor-pointer absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                                        >
                                            {#if showPassword}
                                                <span class="icon-[ri--eye-off-line] w-4 h-4"
                                                ></span>
                                            {:else}
                                                <span class="icon-[ri--eye-line] w-4 h-4"></span>
                                            {/if}
                                        </button>
                                    </div>
                                </div>

                                <!-- Confirm Password -->
                                <div class="space-y-2">
                                    <Label for="confirmPassword"
                                        >{$_("me.settings.confirm_password")}</Label
                                    >
                                    <div class="relative">
                                        <Input
                                            id="confirmPassword"
                                            type={showConfirmPassword ? "text" : "password"}
                                            placeholder={$_(
                                                "me.settings.confirm_password_placeholder",
                                            )}
                                            bind:value={confirmPassword}
                                            required
                                            class="bg-background/50 border-primary/20 focus:border-primary pr-10"
                                        />
                                        <button
                                            type="button"
                                            onclick={() =>
                                                (showConfirmPassword = !showConfirmPassword)}
                                            class="cursor-pointer absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                                        >
                                            {#if showConfirmPassword}
                                                <span class="icon-[ri--eye-off-line] w-4 h-4"
                                                ></span>
                                            {:else}
                                                <span class="icon-[ri--eye-line] w-4 h-4"></span>
                                            {/if}
                                        </button>
                                    </div>
                                </div>
                                {#if isSecurityError}
                                    <div class="grid w-full items-start gap-4">
                                        <Alert.Root variant="destructive">
                                            <Alert.Title class="items-center flex"
                                                ><span
                                                    class="icon-[ri--alert-line] inline-block w-4 h-4 mr-1"
                                                ></span>{$_("me.settings.error")}</Alert.Title
                                            >
                                            <Alert.Description>{securityError}</Alert.Description>
                                        </Alert.Root>
                                    </div>
                                {/if}
                                <Button
                                    variant="outline"
                                    type="submit"
                                    class="cursor-pointer w-full border-primary/20 hover:bg-primary/10"
                                    disabled={isSecurityLoading}
                                >
                                    {#if isSecurityLoading}
                                        <div
                                            class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin mr-2"
                                        ></div>
                                        {$_("me.settings.updating_security")}
                                    {:else}
                                        {$_("me.settings.update_security")}
                                    {/if}
                                </Button>
                            </form>
                        </CardContent>
                    </Card>
                </div>
            </TabsContent>
        </Tabs>
    </div>
</div>
