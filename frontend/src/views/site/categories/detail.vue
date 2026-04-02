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
            <div v-if="photos && photos.length > 0" style="max-height: 100%; padding-bottom: 56px; overflow-y: auto;">
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
                :show-toolbar="true"
                :show-toolbar-tooltip="true"
              />
            </div>
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
  touch-action: auto;
}

</style>
