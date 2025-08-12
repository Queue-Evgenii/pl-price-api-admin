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
  <div style="position: relative;">
  </div>
  <div class="page" position="absolute">
    <loader v-if="isLoading" />
    <div class="flex flex-center main">
      <div class="_container">
        <div class="_sub-container">
          <div class="content"v-if="photos && photos.length > 0">
            <header class="main__header">
              <h2>{{ photos[0].category.name }}</h2>
            </header>
            <section>
              <n-image
                v-for="photo in photos"
                width="100%"
                :key="photo.id"
                object-fit="contain"
                :src="photo.url"
              />
            </section>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page {
  height: 100%;
}
.main__header {
  top: 0;
}
.content {
  position: relative;
  height: 100%;
  overflow: hidden;
  padding: 0;
}
.page {
  padding: 0;
}
.content > section {
  position: absolute;
  top: 56px;
  padding-bottom: 56px;
  max-height: 100%; overflow-y: auto;
}
._sub-container {
  height: 100%;
  padding: 16px 0;
}
._container {
  height: 100%;
}
.main {
  height: 100%;
}
div.n-image {
  width: 100%;
}

</style>