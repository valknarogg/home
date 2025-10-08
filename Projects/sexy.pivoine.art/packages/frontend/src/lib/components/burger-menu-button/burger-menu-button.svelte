<script lang="ts">
const { isMobileMenuOpen = $bindable(), label, onclick } = $props();
</script>

<button
  class="block rounded-full cursor-pointer"
  onclick={onclick}
  aria-label={label}
>
  <div
    class="relative flex overflow-hidden items-center justify-center rounded-full w-[50px] h-[50px] transform transition-all duration-200 shadow-md opacity-90 translate-x-3"
  >
    <div
      class="flex flex-col justify-between w-[16px] h-[10px] transform transition-all duration-300 origin-center overflow-hidden"
    >
      <div
        class={`bg-white h-[2px] w-7 transform transition-all duration-300 origin-left ${isMobileMenuOpen ? 'translate-x-10' : ''}`}
      ></div>
      <div
        class={`bg-white h-[2px] w-7 rounded transform transition-all duration-300 delay-75 ${isMobileMenuOpen ? 'translate-x-10' : ''}`}
      ></div>
      <div
        class={`bg-white h-[2px] w-7 transform transition-all duration-300 origin-left delay-150 ${isMobileMenuOpen ? 'translate-x-10' : ''}`}
      ></div>

      <div
        class={`absolute items-center justify-between transform transition-all duration-500 top-6.5 -translate-x-10 flex w-0 ${isMobileMenuOpen ? 'translate-x-0 w-12' : ''}`}
      >
        <div
          class={`absolute bg-white h-[2px] w-4 transform transition-all duration-500 rotate-0 delay-300 ${isMobileMenuOpen ? 'rotate-45' : ''}`}
        ></div>
        <div
          class={`absolute bg-white h-[2px] w-4 transform transition-all duration-500 -rotate-0 delay-300 ${isMobileMenuOpen ? '-rotate-45' : ''}`}
        ></div>
      </div>
    </div>
  </div>
</button>
