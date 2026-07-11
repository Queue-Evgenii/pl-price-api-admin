export interface EstimateItem {
  id: string;
  title: string;
  categorySlug: string;
  photoId?: number;
  photoUrl?: string;
  lang: string;
  quantity: number;
  unitPrice: number;
  unit: string;
  createdAt: string;
}

export interface EstimateItemInput {
  title: string;
  categorySlug: string;
  photoId?: number;
  photoUrl?: string;
  lang: string;
}
