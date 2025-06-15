import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { UserRequestDto } from 'src/models/http/user-dto';
import { TokenStrategy } from '../token/token.strategy';
import { AuthStrategy } from './auth.strategy';
import { UserStrategy } from '../user/user.strategy';
import { PasswordStrategy } from '../password/password.strategy';
import { TokenPayload } from 'src/models/token-payload';

@Injectable()
export class AuthService implements AuthStrategy {
  constructor(
    @Inject('TokenService') private readonly tokenService: TokenStrategy,
    @Inject('UserService') private readonly userService: UserStrategy,
    @Inject('PasswordService') private readonly passwordService: PasswordStrategy,
  ) {}

  private createToken(payload: TokenPayload): string {
    return 'Bearer ' + this.tokenService.createToken(payload);
  }

  async signIn(user: UserRequestDto) {
    const originUser = await this.userService.findByEmail(user.email);
    if (originUser === null) throw new HttpException('User not found', HttpStatus.NOT_FOUND);

    const isPasswordCorrect = await this.passwordService.compare(user.password, originUser.password);
    if (!isPasswordCorrect) throw new HttpException('Wrong password', HttpStatus.UNAUTHORIZED);
    return {
      token: this.createToken({ email: originUser.email, role: originUser.role }),
      user: originUser,
    };
  }

  async signUp(user: UserRequestDto) {
    const originUser = await this.userService.findByEmail(user.email);
    if (originUser !== null) throw new HttpException('User already exists', HttpStatus.CONFLICT);

    const createdUser = await this.userService.create(user);
    return {
      token: this.createToken({ email: createdUser.email, role: createdUser.role }),
      user: createdUser,
    };
  }
}
