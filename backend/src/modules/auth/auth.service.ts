import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { UserRequestDto } from 'src/models/http/user-dto';
import { TokenStrategy } from '../token/token.strategy';
import { UserService } from '../user/user.service';
import { PasswordService } from '../password/password.service';
import { AuthStrategy } from './auth.strategy';

@Injectable()
export class AuthService implements AuthStrategy {
  constructor(
    @Inject('TokenService') private readonly tokenService: TokenStrategy,
    @Inject('UserService') private readonly userService: UserService,
    @Inject('PasswordService') private readonly passwordService: PasswordService,
  ) {}

  private createToken(user: UserRequestDto): string {
    return this.tokenService.createToken(user);
  }

  async signIn(user: UserRequestDto) {
    const originUser = await this.userService.findByEmail(user.email);
    if (originUser === null) throw new HttpException('User not found', HttpStatus.NOT_FOUND);

    const isPasswordCorrect = await this.passwordService.compare(user.password, originUser.password);
    if (!isPasswordCorrect) throw new HttpException('Wrong password', HttpStatus.UNAUTHORIZED);
    return {
      token: this.createToken(user),
      user: originUser,
    };
  }

  async signUp(user: UserRequestDto) {
    const originUser = await this.userService.findByEmail(user.email);
    if (originUser !== null) throw new HttpException('User already exists', HttpStatus.CONFLICT);

    const createdUser = await this.userService.create(user);
    return {
      token: this.createToken(user),
      user: createdUser,
    };
  }
}
