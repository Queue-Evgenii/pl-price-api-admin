import type { AxiosInstance } from "axios";
import { Api } from "../api";

export class CategoriesApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, 'admin');
  }
  
  getCategories = () => {
    return this.getRequest<unknown>('categories');
  };
}