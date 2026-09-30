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

  downloadTabPcUrl: string;

  downloadTabAndroidButtonText: string;

  downloadTabAndroidEmptyText: string;

  downloadTabAndroidUrl: string;

  downloadTabIosButtonText: string;

  downloadTabIosEmptyText: string;

  downloadTabIosUrl: string;

  cookieText: string;

  cookieAcceptText: string;

  cookieLinkText: string;

  cookieLinkUrl: string;

  banner: PhotoEntity;

  site: string;
}