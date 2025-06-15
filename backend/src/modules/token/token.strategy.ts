import { TokenPayload } from 'src/models/token-payload';

export interface TokenStrategy {
  createToken(user: TokenPayload): string;

  /**
   * If token is not expired it returns true
   * @param token e.g. 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
   * @returns boolean
   */
  verifyToken(token: string): boolean;

  /**
   * If token is not expired it returns true
   * @param token e.g. 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
   * @returns payload
   */
  decodeToken(token: string): TokenPayload;
}
