import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { TokenStrategy } from './token.strategy';
import { TokenPayload } from 'src/models/token-payload';

@Injectable()
export class TokenService implements TokenStrategy {
  constructor(private jwtService: JwtService) {}

  createToken(user: TokenPayload): string {
    return this.jwtService.sign(user);
  }

  verifyToken(token: string): boolean {
    try {
      return !!this.jwtService.verify(token);
    } catch {
      return false;
    }
  }

  decodeToken(token: string): string {
    if (!this.verifyToken(token)) {
      throw new HttpException('Token has expired!', HttpStatus.UNAUTHORIZED);
    }
    return this.jwtService.decode(token);
  }
}
