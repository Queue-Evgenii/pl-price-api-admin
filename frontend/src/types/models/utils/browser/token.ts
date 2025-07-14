export class Token {
  private static readonly TOKEN_KEY = 'price_api_token';

  static get = (): string => {
    return localStorage.getItem(this.TOKEN_KEY) || '';
  };

  static set = (token: string): void => {
    localStorage.setItem(this.TOKEN_KEY, token);
  };

  static exists(): boolean {
    return !!this.get();
  }

  static remove(): void {
    localStorage.removeItem(this.TOKEN_KEY);
  }
}
