<script setup lang="ts">
import type { CategoriesApi } from '@/api/modules/categories';
import type { PhotoEntity } from '@/types/models/entities/photo.entity';
import { inject, onMounted, ref, nextTick, onUnmounted } from 'vue';
import loader from '@/components/loader.vue';
import { usePhotosStore } from '@/stores/photos';
import { ArrowBackIosFilled } from '@vicons/material';
import { useCategoriesStore } from '@/stores/categories';
import { RouteName } from '@/types/constants/route-name';
import { withErrorHandling } from '@/api/api-error-handler';
import CategoryMedia from '@/components/category-media.vue';
import EstimateButton from '@/components/estimate-button.vue';
import EstimateDrawer from '@/components/estimate-drawer.vue';
import { useEstimateStore } from '@/stores/estimate';
import { Capacitor } from '@capacitor/core';
import { useRoute } from 'vue-router';

const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const photos = ref<PhotoEntity[]>([]);
const isLoading = ref<boolean>(false);
const photosStore = usePhotosStore();
const categoriesStore = useCategoriesStore();
const estimateStore = useEstimateStore();
const parentSlug = ref<string | null>();
const isEstimateOpen = ref(false);
const isIos = Capacitor.getPlatform() === 'ios';
const route = useRoute();

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
    const images = document.querySelectorAll('.n-image img');
    images.forEach(img => {
      let scale = 1;
      let initialDistance = 0;
      
      img.addEventListener('touchstart', (e: TouchEvent) => {
        if (e.touches.length === 2) {
          e.preventDefault();
          initialDistance = Math.hypot(
            e.touches[0].pageX - e.touches[1].pageX,
            e.touches[0].pageY - e.touches[1].pageY
          );
        }
      });
      
      img.addEventListener('touchmove', (e: TouchEvent) => {
        if (e.touches.length === 2) {
          e.preventDefault();
          const currentDistance = Math.hypot(
            e.touches[0].pageX - e.touches[1].pageX,
            e.touches[0].pageY - e.touches[1].pageY
          );
          scale = Math.min(Math.max(1, currentDistance / initialDistance), 3);
          (img as HTMLElement).style.transform = `scale(${scale})`;
        }
      });
    });
  });
}

const enableModalZoom = () => {
  const checkModal = setInterval(() => {
    const modalImage = document.querySelector('.n-image-preview img') as HTMLElement;
    if (modalImage && !modalImage.dataset.zoomEnabled) {
      modalImage.dataset.zoomEnabled = 'true';
      let scale = 1;
      let initialDistance = 0;
      let translateX = 0;
      let translateY = 0;
      let startX = 0;
      let startY = 0;
      
      modalImage.addEventListener('touchstart', (e: TouchEvent) => {
        if (e.touches.length === 2) {
          e.preventDefault();
          initialDistance = Math.hypot(
            e.touches[0].pageX - e.touches[1].pageX,
            e.touches[0].pageY - e.touches[1].pageY
          );
        } else if (e.touches.length === 1 && scale > 1) {
          e.preventDefault();
          startX = e.touches[0].pageX - translateX;
          startY = e.touches[0].pageY - translateY;
        }
      });
      
      modalImage.addEventListener('touchmove', (e: TouchEvent) => {
        if (e.touches.length === 2) {
          e.preventDefault();
          const currentDistance = Math.hypot(
            e.touches[0].pageX - e.touches[1].pageX,
            e.touches[0].pageY - e.touches[1].pageY
          );
          scale = Math.min(Math.max(1, currentDistance / initialDistance), 4);
          modalImage.style.transform = `translate(${translateX}px, ${translateY}px) scale(${scale})`;
        } else if (e.touches.length === 1 && scale > 1) {
          e.preventDefault();
          translateX = e.touches[0].pageX - startX;
          translateY = e.touches[0].pageY - startY;
          modalImage.style.transform = `translate(${translateX}px, ${translateY}px) scale(${scale})`;
        }
      });
    }
  }, 100);
  
  return () => clearInterval(checkModal);
}

const cleanupModalZoom = ref<(() => void) | null>(null);

const addPhotoToEstimate = (photo: PhotoEntity) => {
  estimateStore.addItem({
    title: photo.name || photo.category?.name || props.slug || 'Material',
    categorySlug: photo.category?.slug || props.slug,
    photoId: photo.id,
    photoUrl: photo.url,
    lang: String(route.params['lang'] ?? 'pl'),
  });
  isEstimateOpen.value = true;
}

onMounted(() => {
  parentSlug.value = categoriesStore.getFirstParentSlug(props.slug);
  if (photosStore.getPhotosByKey(props.slug).length > 0) {
    bindPhotos();
  } else {
    fetchPhotos();
  }
  cleanupModalZoom.value = enableModalZoom();
})

onUnmounted(() => {
  if (cleanupModalZoom.value) {
    cleanupModalZoom.value();
  }
})
</script>

<template>
  <div style="position: relative;">
  </div>
  <div class="page" :class="{ 'page--ios': isIos }" position="absolute">
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
              <EstimateButton v-if="isIos" @open="isEstimateOpen = true" />
            </header>
            <div v-if="photos && photos.length > 0" style="max-height: 100%; padding-bottom: 56px; overflow-y: auto;">
              <div v-for="photo in photos" :key="photo.id" class="estimate-media">
                <CategoryMedia :media="photo" />
                <n-button v-if="isIos" size="small" secondary class="estimate-media__add" @click="addPhotoToEstimate(photo)">
                  Add to estimate
                </n-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <EstimateDrawer v-if="isIos" v-model:show="isEstimateOpen" />
  </div>
</template>

<style scoped>
.page {
  height: 100%;
}
.main__header {
  top: 0;
  padding: 0 12px;
}
.main__header h2 {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 44px;
  margin-top: 0;
  margin-bottom: 8px;
  padding: 0 44px;
}
.main__header .icon {
  position: absolute;
  left: 0;
  top: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  font-size: 0;
  transform: translateY(-50%);
  cursor: pointer;
}
.main__header .icon svg {
  width: 24px;
  height: 24px;
}
.content {
  position: relative;
  height: 100%;
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
.page--ios ._sub-container {
  padding-top: max(60px, calc(env(safe-area-inset-top, 0px) + 12px));
}
._container {
  height: 100%;
}
.main {
  height: 100%;
}
div.n-image {
  width: 100%;
  touch-action: auto;
}
.estimate-media {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.estimate-media + .estimate-media {
  margin-top: 18px;
}
.estimate-media__add {
  align-self: center;
}

</style>
