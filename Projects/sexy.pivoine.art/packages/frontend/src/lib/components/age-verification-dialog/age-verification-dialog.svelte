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
import { onMount } from "svelte";

const AGE_VERIFICATION_KEY = "age-verified";

let isOpen = true;

function handleAgeConfirmation() {
	localStorage.setItem(AGE_VERIFICATION_KEY, "true");
	isOpen = false;
}

onMount(() => {
	const storedVerification = localStorage.getItem(AGE_VERIFICATION_KEY);
	if (storedVerification === "true") {
		isOpen = false;
	}
});
</script>

<Dialog bind:open={isOpen}>
    <DialogContent
        class="sm:max-w-md"
        onInteractOutside={(e) => e.preventDefault()}
        showCloseButton={false}
    >
        <DialogHeader class="space-y-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div
                        class="w-10 h-10 shrink-0 grow-0 rounded-full bg-gradient-to-br from-primary to-purple-600 flex items-center justify-center"
                    >
                        <span class="text-primary-foreground text-sm"
                            >{$_("age_verification_dialog.age")}</span
                        >
                    </div>
                    <div class="">
                        <DialogTitle class="text-left text-xl font-semibold text-primary-foreground"
                            >{$_("age_verification_dialog.title")}</DialogTitle
                        >
                        <DialogDescription class="text-left text-sm">
                            {$_("age_verification_dialog.description")}
                        </DialogDescription>
                    </div>
                </div>
            </div>
        </DialogHeader>

        <Separator class="my-4" />

        <!-- Close Button -->
        <div class="flex justify-end gap-4">
            <Button variant="destructive" href={$_("age_verification_dialog.exit_url")} size="sm">
                {$_("age_verification_dialog.exit")}
            </Button>
            <Button
                variant="default"
                size="sm"
                onclick={handleAgeConfirmation}
                class="cursor-pointer"
            >
                <span class="icon-[ri--check-line]"></span>
                {$_("age_verification_dialog.confirm")}
            </Button>
        </div>
    </DialogContent>
</Dialog>
