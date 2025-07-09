import type { CategoryEntity } from '@/types/models/entities/category.entity';
import { defineStore } from 'pinia';

interface CategoriesState {
  _categories: CategoryEntity[];
}

export const useCategoriesStore = defineStore('categories', {
  state: (): CategoriesState => ({
    _categories: [],
  }),
  getters: {
    categories(): CategoryEntity[] {
      return this._categories;
    },
  },
  actions: {
    setCategories(categories: CategoryEntity[]) {
      this._categories = categories;
    },
    addCategory(category: CategoryEntity) {
      if (category.parent && category.parent.id) {
        const insertIntoParent = (categories: CategoryEntity[]): boolean => {
          for (const item of categories) {
            if (item.id === category.parent!.id) {
              if (!item.children) {
                item.children = [];
              }

              item.children.unshift(category);
              return true;
            }

            if (item.children?.length) {
              const inserted = insertIntoParent(item.children);
              if (inserted) return true;
            }
          }

          return false;
        };

        const inserted = insertIntoParent(this._categories);

        if (!inserted) {
          console.warn(`Parent with id=${category.parent.id} not found. Inserted into the root.`);
          this._categories.unshift(category);
        }

        return;
      }

      this._categories.unshift(category);
    },
    replaceCategory(updatedCategory: CategoryEntity) {
      const replaceRecursive = (categories: CategoryEntity[]): boolean => {
        for (let i = 0; i < categories.length; i++) {
          const category = categories[i];

          if (category.id === updatedCategory.id) {
            categories[i] = updatedCategory;
            return true;
          }

          if (category.children?.length) {
            const found = replaceRecursive(category.children);
            if (found) return true;
          }
        }
        return false;
      };

      replaceRecursive(this._categories);
    },
  },
});