<script>
import { _ } from "svelte-i18n";
import SharingPopup from "./sharing-popup.svelte";
import Button from "../ui/button/button.svelte";

const { content } = $props();
let isPopupOpen = $state(false);
</script>

<Button
  onclick={() => (isPopupOpen = true)}
  variant="outline"
  size="sm"
  class="flex items-center gap-2 border-primary/20 hover:bg-primary/10 cursor-pointer"
>
  <span class="icon-[ri--share-2-line] w-4 h-4"></span>
  {$_('sharing_popup_button.share')}
</Button>
<SharingPopup bind:open={isPopupOpen} {content} />
