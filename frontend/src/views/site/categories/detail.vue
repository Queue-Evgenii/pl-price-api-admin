<script setup lang="ts">
import type { CategoriesApi } from '@/api/modules/categories';
import type { PhotoEntity } from '@/types/models/entities/photo.entity';
import { inject, onMounted, ref, nextTick } from 'vue';
import loader from '@/components/loader.vue';
import { usePhotosStore } from '@/stores/photos';
import { ArrowBackIosFilled } from '@vicons/material';
import { useCategoriesStore } from '@/stores/categories';
import { RouteName } from '@/types/constants/route-name';
import { withErrorHandling } from '@/api/api-error-handler';

const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const photos = ref<PhotoEntity[]>([]);
const isLoading = ref<boolean>(false);
const photosStore = usePhotosStore();
const categoriesStore = useCategoriesStore();
const parentSlug = ref<string | null>();

const props = defineProps({
  slug: {
    type: String,
    required: true,
  },
})

const bindPhotos =  () => {
  photos.value = photosStore.getPhotosByKey(props.slug);
}

const fetchPhotos = async () => {
  isLoading.value = true;
  photos.value = (await withErrorHandling(categoriesApi.getPhotos(props.slug))).data.filter(p => p.isActive);
  photosStore.setPhotosByKey(props.slug, photos.value);
  isLoading.value = false;
}

const enableZoom = () => {
  nextTick(() => {
    const viewport = document.querySelector('meta[name="viewport"]');
    if (viewport) {
      viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, user-scalable=yes, maximum-scale=5.0');
    }
  });
}

onMounted(() => {
  parentSlug.value = categoriesStore.getFirstParentSlug(props.slug);
  if (photosStore.getPhotosByKey(props.slug).length > 0) {
    bindPhotos();
  } else {
    fetchPhotos();
  }
  enableZoom();
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
          <div class="content">
            <header class="main__header">
              <h2>
                <router-link :to="parentSlug ? { name: RouteName.SITE.CATEGORIES.SLUG, params: { slug: parentSlug } } : { name: RouteName.SITE.CATEGORIES.ROOT }" class="icon">
                  <ArrowBackIosFilled  />
                </router-link>
                <span>{{ photos && photos.length > 0 ? photos[0].category.name : "Oops! Nothing here :(" }}</span>
              </h2>
            </header>
            <n-scrollbar style="max-height: 100%; padding-bottom: 56px;" v-if="photos && photos.length > 0">
              <n-image
                v-for="photo in photos"
                width="100%"
                :key="photo.id"
                object-fit="contain"
                :src="photo.url"
                :preview-props="{
                  gesture: {
                    scale: true,
                    pan: true,
                    pinch: true
                  }
                }"
              />
            </n-scrollbar>
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
.main__header h2 {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}
.main__header .icon {
  position: absolute;
  left: 0;
  width: 24px;
  height: 24px;
  font-size: 0;
  cursor: pointer;
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

/* Enable zoom for mobile devices */
@media (max-width: 768px) {
  .page {
    zoom: 1;
    transform-origin: 0 0;
  }
  
  .content {
    zoom: 1;
    transform-origin: 0 0;
  }
}

</style>
