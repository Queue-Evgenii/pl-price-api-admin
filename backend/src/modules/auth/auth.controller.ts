import { Body, Controller, Inject, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UserRequestDto, UserResponseDto } from 'src/models/http/user-dto';
import { ApiTags } from '@nestjs/swagger';
import { ApiSignInResponses, ApiSignUpResponses } from '../../decorators/auth.decorator';

@ApiTags('Auth')
@Controller()
export class AuthController {
  constructor(@Inject('AuthService') private authService: AuthService) {}

  @Post('sign-in')
  @ApiSignInResponses()
  signIn(@Body() user: UserRequestDto): Promise<UserResponseDto> {
    return this.authService.signIn(user);
  }

  @Post('sign-up')
  @ApiSignUpResponses()
  signUp(@Body() user: UserRequestDto): Promise<UserResponseDto> {
    return this.authService.signUp(user);
  }
}
