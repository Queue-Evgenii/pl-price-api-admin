import type { PhotoEntity } from '@/types/models/entities/photo.entity';
import { defineStore } from 'pinia';

interface PhotosState {
  _photos: PhotoEntity[];
}

export const usePhotosStore = defineStore('photos', {
  state: (): PhotosState => ({
    _photos: [],
  }),
  getters: {
    photos(): PhotoEntity[] {
      return this._photos;
    },
  },
  actions: {
    setPhotos(photos: PhotoEntity[]) {
      this._photos = photos;
    },
    addPhoto(photo: PhotoEntity) {
      if (this._photos.some(e => e.id === photo.id)) return;

      this._photos.push(photo);
    },
  },
});