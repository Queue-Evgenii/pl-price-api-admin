import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { CategoriesDto, CreateCategoryDto } from "@/types/models/dto/categories-dto";
import type { CategoryEntity } from "@/types/models/entities/category.entity";
import type { _DeepPartial } from "pinia";

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
  
  patchCategory = (id: number, payload: _DeepPartial<CategoryEntity>) => {
    return this.patchRequest<CategoryEntity, _DeepPartial<CategoryEntity>>(`/categories/${id}`, payload);
  };
  
  deleteCategory = (id: number) => {
    return this.deleteRequest<void>(`/categories/${id}`);
  };
}