import { Body, Controller, Inject, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UserRequestDto } from 'src/models/http/user-dto';

@Controller()
export class AuthController {
  constructor(@Inject('AuthService') private authService: AuthService) {}

  @Post('sign-in')
  signIn(@Body() user: UserRequestDto) {
    return this.authService.signIn(user);
  }

  @Post('sign-up')
  signUp(@Body() user: UserRequestDto) {
    return this.authService.signUp(user);
  }
}
