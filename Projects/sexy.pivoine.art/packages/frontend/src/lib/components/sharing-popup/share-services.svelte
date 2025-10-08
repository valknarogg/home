<script lang="ts">
import { _ } from "svelte-i18n";
import ShareButton from "./share-button.svelte";
import { toast } from "svelte-sonner";
import type { ShareContent } from "$lib/types";

interface Props {
	content: ShareContent;
}

let { content }: Props = $props();

// Share handlers
const shareToX = () => {
	const text = `${content.title} - ${content.description}`;
	const url = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(content.url)}`;
	window.open(url, "_blank", "width=600,height=400");
	toast.success($_("sharing_popup.success.x"));
};

const shareToFacebook = () => {
	const url = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(content.url)}&quote=${encodeURIComponent(content.title)}`;
	window.open(url, "_blank", "width=600,height=400");
	toast.success($_("sharing_popup.success.facebook"));
};

const shareViaEmail = () => {
	const subject = encodeURIComponent(content.title);
	const body = encodeURIComponent(`${content.description}\n\n${content.url}`);
	const url = `mailto:?subject=${subject}&body=${body}`;
	window.location.href = url;
	toast.success($_("sharing_popup.success.email"));
};

const shareToWhatsApp = () => {
	const text = `${content.title}\n\n${content.description}\n\n${content.url}`;
	const url = `https://wa.me/?text=${encodeURIComponent(text)}`;
	window.open(url, "_blank");
	toast.success($_("sharing_popup.success.whatsapp"));
};

const shareToTelegram = () => {
	const text = `${content.title}\n\n${content.description}`;
	const url = `https://t.me/share/url?url=${encodeURIComponent(content.url)}&text=${encodeURIComponent(text)}`;
	window.open(url, "_blank");
	toast.success($_("sharing_popup.success.telegram"));
};

const copyLink = async () => {
	try {
		await navigator.clipboard.writeText(content.url);
		toast.success($_("sharing_popup.success.copy"));
	} catch (err) {
		// Fallback for older browsers
		const textArea = document.createElement("textarea");
		textArea.value = content.url;
		document.body.appendChild(textArea);
		textArea.select();
		document.execCommand("copy");
		document.body.removeChild(textArea);
		toast.success($_("sharing_popup.success.copy"));
	}
};
</script>

<div class="space-y-6">
    <div class="text-center space-y-4">
        <h4 class="text-sm font-medium text-muted-foreground">
            {$_("sharing_popup.subtitle")}
        </h4>

        <div class="flex justify-center gap-3 flex-wrap">
            <ShareButton
                onclick={shareToX}
                icon="icon-[ri--twitter-x-line]"
                label={$_("sharing_popup.share.x")}
            />

            <ShareButton
                onclick={shareToFacebook}
                icon="icon-[ri--facebook-line]"
                label={$_("sharing_popup.share.facebook")}
            />

            <ShareButton
                onclick={shareViaEmail}
                icon="icon-[ri--mail-line]"
                label={$_("sharing_popup.share.email")}
            />

            <ShareButton
                onclick={shareToWhatsApp}
                icon="icon-[ri--whatsapp-line]"
                label={$_("sharing_popup.share.whatsapp")}
            />

            <ShareButton
                onclick={shareToTelegram}
                icon="icon-[ri--telegram-2-line]"
                label={$_("sharing_popup.share.telegram")}
            />

            <ShareButton
                onclick={copyLink}
                icon="icon-[ri--file-copy-line]"
                label={$_("sharing_popup.share.copy")}
            />
        </div>
    </div>
</div>
