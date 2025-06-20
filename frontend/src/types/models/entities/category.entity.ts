export interface CategoryEntity {
  id: number;

  name: string;

  slug: string;

  parent?: CategoryEntity;

  children: CategoryEntity[];
}