import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { CategoryEntity } from "@/types/models/entities/category.entity";

export class CategoriesApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '/admin');
  }
  
  getCategories = () => {
    return this.getRequest<CategoryEntity[]>('/categories');
  };
}