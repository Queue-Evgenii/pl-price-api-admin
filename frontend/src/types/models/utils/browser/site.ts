export class Site {
  private static readonly SITE_KEY = 'price_api_site';

  static get = (): string => {
    return localStorage.getItem(this.SITE_KEY) || '';
  };

  static set = (value: string): void => {
    localStorage.setItem(this.SITE_KEY, value);
  };

  static exists(): boolean {
    return !!this.get();
  }

  static remove(): void {
    localStorage.removeItem(this.SITE_KEY);
  }
}
