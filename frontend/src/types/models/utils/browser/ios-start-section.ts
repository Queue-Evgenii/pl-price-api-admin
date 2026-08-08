import { Capacitor } from '@capacitor/core';

export type IosStartSection = 'planner' | 'catalog';

export class IosStartSectionStorage {
  private static readonly SECTION_KEY = 'price_api_ios_start_section';

  static isIos = (): boolean => Capacitor.getPlatform() === 'ios';

  static get = (): IosStartSection => {
    if (!this.isIos()) return 'planner';
    const value = localStorage.getItem(this.SECTION_KEY);
    return value === 'catalog' ? 'catalog' : 'planner';
  };

  static set = (value: IosStartSection): void => {
    if (!this.isIos()) return;
    localStorage.setItem(this.SECTION_KEY, value);
  };
}
