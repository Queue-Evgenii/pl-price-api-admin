import type { CategoryEntity } from "../entities/category.entity";

export interface SitesDto {
  data: CategoryEntity[];
}

export interface CreateSiteDto {
  name: string;
  code: string;
  active: boolean;
}