import { Injectable, CanActivate, ExecutionContext, Inject } from '@nestjs/common';
import { IncomingMessage } from 'http';
import { TokenRequestDto } from 'src/models/http/token-dto';
import { UserRoles } from 'src/models/roles';
import { TokenStrategy } from 'src/modules/token/token.strategy';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(@Inject('TokenService') private readonly tokenService: TokenStrategy) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<IncomingMessage>();
    const tokenInstance = new TokenRequestDto(request.headers.authorization as string);

    const payload = this.tokenService.decodeToken(tokenInstance.getToken());
    return payload.role === UserRoles.ADMIN;
  }
}
