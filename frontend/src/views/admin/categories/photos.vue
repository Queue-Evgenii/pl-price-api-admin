<script setup lang="ts">
import { inject, onMounted } from 'vue'
import { type UploadFileInfo } from 'naive-ui'
import type { CategoriesApi } from '@/api/modules/categories';
import type { PhotoEntity } from '@/types/models/entities/photo.entity';
import { usePhotosStore } from '@/stores/photos';
import type { UpdatePhotosDto } from '@/types/models/dto/photos-dto';
import { DeleteFilled, AddCircleFilled, ArrowDropUpFilled, ArrowDropDownFilled } from '@vicons/material'

const categoriesApi = inject<CategoriesApi>('CategoriesApi')!;
const photosStore = usePhotosStore();
const props = defineProps<{ slug: string }>();

const fetchPhotos = async () => {
  try {
    const { data } = await categoriesApi.getPhotos(props.slug);
    photosStore.setPhotos(data);
  } catch (error) {
    console.error('Photo fetch error:', error);
  }
}

const createPhotos = async (file: File) => {
  try {
    const createdPhoto = await categoriesApi.addPhoto(props.slug, file);
    photosStore.addPhoto(createdPhoto);
  } catch (error) {
    console.error('Photo creating error:', error);
  }
}

const updatePhoto = async (photoId: number, dto: UpdatePhotosDto) => {
  try {
    const { data } = await categoriesApi.updatePhoto(photoId, dto);
    photosStore.setPhotos(data);
  } catch (error) {
    console.error('Photo updating error:', error);
  }
}

const removePhoto = async (photoId: number) => {
  try {
    const { data } = await categoriesApi.deletePhoto(photoId);
    photosStore.setPhotos(data);
  } catch (error) {
    console.error('Photo deleting error:', error);
  }
}

const handleUpload = async ({ file }: { file: UploadFileInfo }) => {
  if (!file.file) return;

  createPhotos(file.file as File);
};

const customRequest = () => {
  return new Promise(() => {})
}

const moveUp = (photo: PhotoEntity) => {
  if (photo.orderId > 1) {
    updatePhoto(photo.id, { orderId: photo.orderId - 1 })
  }
}

const moveDown = (photo: PhotoEntity) => {
  if (photo.orderId < photosStore.photos.length) {
    updatePhoto(photo.id, { orderId: photo.orderId + 1 })
  }
}

const switchStatus = (photo: PhotoEntity, newStatus: boolean) => {
  updatePhoto(photo.id, { isActive: newStatus })
}

onMounted(() => {
  fetchPhotos();
});
</script>

<template>
  <n-card title="Photos management" class="max-w-2xl mx-auto mt-8">
    <div class="space-y-4">
      <n-upload
        accept="image/*"
        :show-file-list="false"
        @change="handleUpload"
        :custom-request="customRequest"
        style="margin-bottom: 16px;"
      >
        <n-button type="primary">
          <template #icon>
            <AddCircleFilled />
          </template>
          Add image
        </n-button>
      </n-upload>

      <n-list bordered id="image-scroll-container" style="width: fit-content;">
        <n-list-item v-for="image in photosStore.photos" :key="image.id">
          <n-flex :align="'center'" :size="32">
            <n-flex vertical>
              <n-button
                size="small"
                @click="moveUp(image)"
                :disabled="image.orderId === 1"
              >
                <template #icon>
                  <ArrowDropUpFilled />
                </template>
              </n-button>
              <n-button
                size="small"
                @click="moveDown(image)"
                :disabled="image.orderId === photosStore.photos.length"
              >
                <template #icon>
                  <ArrowDropDownFilled />
                </template>
              </n-button>
            </n-flex>
            <div>
              <n-flex :align="'center'" :size="32">
              <n-card hoverable style="flex: 0 0 auto; width: min-content; margin-right: 24px;">
                <n-image
                  object-fit="contain"
                  width="200"
                  height="200"
                  lazy
                  :src="image.url"
                  :intersection-observer-options="{
                    root: '#image-scroll-container',
                  }"
                >
                  <template #placeholder>
                      <n-skeleton height="100px" width="100px" />
                  </template>
                </n-image>
              </n-card>
              <n-switch v-model:value="image.isActive" @update:value="(value: boolean) => switchStatus(image, value)"  :round="false" size="large" />
              <n-button size="small" type="error" @click="removePhoto(image.id)">
                <template #icon>
                  <DeleteFilled />
                </template>
                Delete
              </n-button>
            </n-flex>
            <span v-if="image.name">{{ image.name.split('--')[0] + '.' + image.name.split('.')[1] }}</span>
            </div>
          </n-flex>
        </n-list-item>
      </n-list>
    </div>
  </n-card>
</template>

<style scoped>
img {
  transition: transform 0.2s ease;
}
</style>
