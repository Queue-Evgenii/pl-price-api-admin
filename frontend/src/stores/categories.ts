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

              item.children.push(category);
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
          this._categories.push(category);
        }

        return;
      }

      this._categories.push(category);
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
    deleteCategoryWithId(id: number) {
      const deleteRecursive = (categories: CategoryEntity[]): boolean => {
        for (let i = 0; i < categories.length; i++) {
          const category = categories[i];

          if (category.id === id) {
            categories.splice(i, 1);
            return true;
          }

          if (category.children?.length) {
            const deleted = deleteRecursive(category.children);
            if (deleted) return true;
          }
        }

        return false;
      };

      deleteRecursive(this._categories);
    },

    swapCategoriesById(id1: number, id2: number) {
      const swapOnSameLevel = (categories: CategoryEntity[]): boolean => {
        const index1 = categories.findIndex(cat => cat.id === id1);
        const index2 = categories.findIndex(cat => cat.id === id2);

        if (index1 !== -1 && index2 !== -1) {
          [categories[index1], categories[index2]] = [categories[index2], categories[index1]];

          const tempOrderId = categories[index1].orderId;
          categories[index1].orderId = categories[index2].orderId;
          categories[index2].orderId = tempOrderId;

          return true;
        }

        for (const cat of categories) {
          if (cat.children?.length) {
            const swapped = swapOnSameLevel(cat.children);
            if (swapped) return true;
          }
        }

        return false;
      };

      const swapped = swapOnSameLevel(this._categories);

      if (!swapped) {
        console.warn(`Categories with id=${id1} and id=${id2} not found on the same level.`);
      }
    }
  },
});