import { HttpException, HttpStatus, Inject, Injectable } from '@nestjs/common';
import { UserDto } from 'src/models/user-dto';
import { TokenStrategy } from '../token/token.strategy';
import { UserService } from '../user/user.service';
import { PasswordService } from '../password/password.service';

@Injectable()
export class AuthService {
  constructor(
    @Inject('TokenService') private readonly tokenService: TokenStrategy,
    @Inject('UserService') private readonly userService: UserService,
    @Inject('PasswordService') private readonly passwordService: PasswordService,
  ) {}

  private createToken(user: UserDto): string {
    return this.tokenService.createToken(user);
  }

  async signIn(user: UserDto) {
    const originUser = await this.userService.findByEmail(user.email);
    if (originUser === null)
      throw new HttpException('User not found', HttpStatus.BAD_REQUEST);

    const isPasswordCorrect = await this.passwordService.compare(
      user.password,
      originUser.password,
    );
    if (!isPasswordCorrect)
      throw new HttpException('Wrong password', HttpStatus.UNAUTHORIZED);
    return this.createToken(user);
  }

  async signUp(user: UserDto) {
    await this.userService.create(user);
    return this.createToken(user);
  }
}
