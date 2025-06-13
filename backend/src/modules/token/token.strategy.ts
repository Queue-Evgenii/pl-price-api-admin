import { TokenPayload } from 'src/models/token-payload';

export interface TokenStrategy {
  createToken(user: TokenPayload): string;

  verifyToken(token: string): boolean;

  decodeToken(token: string): string;
}
