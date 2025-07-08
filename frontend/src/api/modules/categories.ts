import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { CategoriesDto } from "@/types/models/dto/categories-dta";

export class CategoriesApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '/admin');
  }
  
  getCategories = () => {
    return this.getRequest<CategoriesDto>('/categories');
  };
}