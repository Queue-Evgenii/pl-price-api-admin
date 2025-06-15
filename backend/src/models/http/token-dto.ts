export class TokenRequestDto {
  constructor(private rawToken: string) {}

  getTag() {
    return this.rawToken.split(' ')[0];
  }

  getToken() {
    return this.rawToken.split(' ')[1];
  }

  getRaw() {
    return this.rawToken;
  }
}