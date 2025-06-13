import {
  Injectable,
  CanActivate,
  ExecutionContext,
  Inject,
} from '@nestjs/common';
import { IncomingMessage } from 'http';
import { TokenStrategy } from 'src/modules/token/token.strategy';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    @Inject('TokenService') private readonly tokenService: TokenStrategy,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<IncomingMessage>();
    const authHeader = request.headers.authorization as string;

    return this.tokenService.verifyToken(authHeader);
  }
}
