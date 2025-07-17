<script setup lang="ts">
import type { CategoriesApi } from '@/api/modules/categories';
import type { PhotoEntity } from '@/types/models/entities/photo.entity';
import { inject, onMounted, ref } from 'vue';
import loader from '@/components/loader.vue';

const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const photos = ref<PhotoEntity[]>([]);
const isLoading = ref<boolean>(true);

const props = defineProps({
  slug: {
    type: String,
    required: true,
  },
})

onMounted(async () => {
  photos.value = (await categoriesApi.getPhotos(props.slug)).data.filter(p => p.isActive);
  isLoading.value = false;
})
</script>

<template>
  <loader v-if="isLoading" />
  <div v-else style="position: relative;">
    <n-image
      v-for="photo in photos"
      width="100%"
      :key="photo.id"
      object-fit="contain"
      :src="photo.url"
    />
  </div>
</template>

<style scoped>
.page {
  background: none;
}
</style>