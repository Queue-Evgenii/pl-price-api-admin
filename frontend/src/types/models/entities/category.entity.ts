export interface CategoryEntity {
  id: number;

  name: string;

  slug: string;

  parent?: CategoryEntity | Partial<CategoryEntity>;

  children: CategoryEntity[];

  countPhotos: number;
}