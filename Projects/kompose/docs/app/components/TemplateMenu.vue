<template>
  <UDropdownMenu v-slot="{ open }" :modal="false" :items="[{
    label: 'Blog',
    to: 'https://pivoine.art'
  }, {
    label: 'Code',
    to: 'https://code.pivoine.art'
  }, {
    label: 'Docs',
    to: 'https://docs.pivoine.art/',
    children: [
      {
        label: 'Kompose',
        to: 'https://docs.pivoine.art/kompose',
        color: 'primary',
        checked: true,
        type: 'checkbox'
      }
    ]
  }, {
    label: 'Sexy',
    to: 'https://sexy.pivoine.art'
  }]" :content="{ align: 'start' }" :ui="{ content: 'min-w-fit' }" size="xs">
    <UButton label="Docs" variant="subtle" trailing-icon="i-lucide-chevron-down" size="xs"
      class="-mb-[6px] font-semibold rounded-full truncate" :class="[open && 'bg-primary/15']" :ui="{
        trailingIcon: ['transition-transform duration-200', open ? 'rotate-180' : undefined].filter(Boolean).join(' ')
      }" />
  </UDropdownMenu>
</template>
