<script lang="ts">
import { _ } from "svelte-i18n";
import {
	Dialog,
	DialogContent,
	DialogDescription,
	DialogHeader,
	DialogTitle,
} from "$lib/components/ui/dialog";
import { Button } from "$lib/components/ui/button";
import { Separator } from "$lib/components/ui/separator";
import ShareServices from "./share-services.svelte";
import type { Snippet } from "svelte";

interface ShareContent {
	title: string;
	description: string;
	url: string;
	type: "video" | "model" | "article" | "link";
}

interface Props {
	open: boolean;
	content: ShareContent;
	children?: Snippet;
}

let { open = $bindable(), content }: Props = $props();
</script>

<Dialog bind:open>
    <DialogContent class="sm:max-w-md">
        <DialogHeader class="space-y-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div
                        class="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-purple-600 flex items-center justify-center shrink-0 grow-0"
                    >
                        <span class="icon-[ri--share-2-line] text-primary-foreground"></span>
                    </div>
                    <div class="">
                        <DialogTitle class="text-left text-xl font-semibold text-primary-foreground"
                            >{$_("sharing_popup.title")}</DialogTitle
                        >
                        <DialogDescription class="text-left text-sm">
                            {$_("sharing_popup.description", {
                                values: { type: content.type },
                            })}
                        </DialogDescription>
                    </div>
                </div>
            </div>

            <!-- Content Preview -->
            <div class="text-left bg-muted/60 rounded-lg p-4 space-y-2">
                <h4 class="font-medium text-sm text-primary-foreground">
                    {content.title}
                </h4>
                <p class="text-xs text-muted-foreground">{content.description}</p>
                <div class="flex items-center gap-2 text-xs">
                    <span class="px-2 py-1 bg-primary/10 text-primary rounded-full capitalize">
                        {content.type}
                    </span>
                    <span class="text-muted-foreground text-clip">{content.url}</span>
                </div>
            </div>
        </DialogHeader>

        <Separator class="my-4" />

        <!-- Share Services -->
        <ShareServices {content} />

        <Separator class="my-4" />

        <!-- Close Button -->
        <div class="flex justify-end">
            <Button
                variant="ghost"
                size="sm"
                onclick={() => (open = false)}
                class="text-muted-foreground hover:text-foreground cursor-pointer"
            >
                <span class="icon-[ri--close-large-line]"></span>
                {$_("sharing_popup.close")}
            </Button>
        </div>
    </DialogContent>
</Dialog>
