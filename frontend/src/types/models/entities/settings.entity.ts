import type { PhotoEntity } from "./photo.entity";

export interface SettingsEntity {
  id: number;
  
  title: string;

  downloadSectionButtonText: string;

  downloadTabPcTitle: string;

  downloadTabAndroidTitle: string;

  downloadTabIosTitle: string;

  downloadTabPcButtonText: string;

  downloadTabPcEmptyText: string;

  downloadTabAndroidButtonText: string;

  downloadTabAndroidEmptyText: string;

  downloadTabIosButtonText: string;

  downloadTabIosEmptyText: string;

  banner: PhotoEntity;

  site: string;
}