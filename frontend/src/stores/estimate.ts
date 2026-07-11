import { defineStore } from 'pinia';
import type { EstimateItem, EstimateItemInput } from '@/types/models/estimate-item';

const STORAGE_KEY = 'price-api-admin-estimate';

interface EstimateState {
  _items: EstimateItem[];
}

const readItems = (): EstimateItem[] => {
  if (typeof localStorage === 'undefined') {
    return [];
  }

  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];

    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
};

const createId = () => `${Date.now()}-${Math.random().toString(36).slice(2, 10)}`;

export const useEstimateStore = defineStore('estimate', {
  state: (): EstimateState => ({
    _items: readItems(),
  }),
  getters: {
    items(): EstimateItem[] {
      return this._items;
    },
    count(): number {
      return this._items.length;
    },
    total(): number {
      return this._items.reduce((sum, item) => sum + item.quantity * item.unitPrice, 0);
    },
  },
  actions: {
    persist() {
      if (typeof localStorage === 'undefined') {
        return;
      }

      localStorage.setItem(STORAGE_KEY, JSON.stringify(this._items));
    },
    addItem(input: EstimateItemInput) {
      this._items.unshift({
        id: createId(),
        title: input.title,
        categorySlug: input.categorySlug,
        photoId: input.photoId,
        photoUrl: input.photoUrl,
        lang: input.lang,
        quantity: 1,
        unitPrice: 0,
        unit: 'pcs',
        createdAt: new Date().toISOString(),
      });
      this.persist();
    },
    updateItem(id: string, patch: Partial<Pick<EstimateItem, 'quantity' | 'unitPrice' | 'unit'>>) {
      const item = this._items.find(el => el.id === id);
      if (!item) {
        return;
      }

      Object.assign(item, patch);
      this.persist();
    },
    deleteItem(id: string) {
      this._items = this._items.filter(item => item.id !== id);
      this.persist();
    },
    clear() {
      this._items = [];
      this.persist();
    },
    exportText(): string {
      const lines = [
        'Material estimate',
        '',
        ...this._items.map((item, index) => {
          const subtotal = item.quantity * item.unitPrice;
          return [
            `${index + 1}. ${item.title}`,
            `Category: ${item.categorySlug}`,
            `Quantity: ${item.quantity} ${item.unit}`,
            `Unit price: ${item.unitPrice.toFixed(2)} zł`,
            `Subtotal: ${subtotal.toFixed(2)} zł`,
          ].filter(Boolean).join('\n');
        }),
        '',
        `Total: ${this.total.toFixed(2)} zł`,
      ];

      return lines.join('\n\n');
    },
  },
});
