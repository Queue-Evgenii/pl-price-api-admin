<script setup lang="ts">
import type { PhotoEntity } from '@/types/models/entities/photo.entity';
import { computed } from 'vue';

const props = defineProps<{ media: PhotoEntity }>();

// Returns an embeddable URL for YouTube/Vimeo links, or null for direct video files.
const embedUrl = computed<string | null>(() => {
  const url = props.media.url;

  const youtube = url.match(/(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([\w-]{11})/);
  if (youtube) return `https://www.youtube.com/embed/${youtube[1]}`;

  const vimeo = url.match(/vimeo\.com\/(?:video\/)?(\d+)/);
  if (vimeo) return `https://player.vimeo.com/video/${vimeo[1]}`;

  return null;
});
</script>

<template>
  <n-image
    v-if="media.type !== 'video'"
    width="100%"
    object-fit="contain"
    :src="media.url"
    :preview-props="{
      gesture: {
        scale: true,
        pan: true,
        pinch: true
      }
    }"
    :show-toolbar="true"
    :show-toolbar-tooltip="true"
  />
  <div v-else class="category-video">
    <iframe
      v-if="embedUrl"
      :src="embedUrl"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen
    />
    <video v-else controls :src="media.url" preload="metadata" />
  </div>
</template>

<style scoped>
.category-video {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
}
.category-video iframe,
.category-video video {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  border: 0;
  background: #000;
}
</style>
