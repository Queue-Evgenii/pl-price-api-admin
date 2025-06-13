import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UserDto } from 'src/models/user-dto';

@Controller()
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('sign-in')
  signIn(@Body() user: UserDto) {
    return this.authService.signIn(user);
  }

  @Post('sign-up')
  signUp(@Body() user: UserDto) {
    return this.authService.signUp(user);
  }
}
