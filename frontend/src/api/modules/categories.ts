import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { CategoriesDto, CreateCategoryDto } from "@/types/models/dto/categories-dto";
import type { CategoryEntity } from "@/types/models/entities/category.entity";
import type { _DeepPartial } from "pinia";
import type { PhotosDto, UpdatePhotosDto } from "@/types/models/dto/photos-dto";
import type { PhotoEntity } from "@/types/models/entities/photo.entity";

export class CategoriesApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '/admin');
  }
  
  getCategories = (params: { page: number, limit: number }) => {
    return this.getRequest<CategoriesDto>('/categories', params);
  };
  
  createCategory = (payload: CreateCategoryDto) => {
    return this.postRequest<CategoryEntity, CreateCategoryDto>('/categories', payload);
  };
  
  updateCategory = (id: number, payload: _DeepPartial<CategoryEntity>) => {
    return this.patchRequest<CategoryEntity, _DeepPartial<CategoryEntity>>(`/categories/${id}`, payload);
  };
  
  deleteCategory = (id: number) => {
    return this.deleteRequest<void>(`/categories/${id}`);
  };

  getPhotos = (id: number) => {
    return this.getRequest<PhotosDto>(`/categories/${id}/photos`);
  };
  
  addPhoto = (id: number, file: File) => {
    const formData = new FormData();
    formData.append('file', file);

    return this.postRequest<PhotoEntity, FormData>(`/categories/${id}/photos`, formData, { headers: { 'Content-Type': 'multipart/form-data' } });
  };
  
  updatePhoto = (id: number, payload: UpdatePhotosDto) => {
    return this.patchRequest<PhotosDto, UpdatePhotosDto>(`/photos/${id}`, payload);
  };
  
  deletePhoto = (id: number) => {
    return this.deleteRequest<PhotosDto>(`/photos/${id}`);
  };
}