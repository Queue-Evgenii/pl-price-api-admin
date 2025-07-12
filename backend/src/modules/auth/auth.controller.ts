import { Body, Controller, Get, HttpException, HttpStatus, Inject, Post, Req } from '@nestjs/common';
import { UserRequestDto, UserResponseDto } from 'src/models/http/user-dto';
import { ApiTags } from '@nestjs/swagger';
import { ApiSignInResponses, ApiSignUpResponses } from '../../decorators/auth.decorator';
import { AuthStrategy } from './auth.strategy';
import { TokenStrategy } from '../token/token.strategy';

@ApiTags('Auth')
@Controller()
export class AuthController {
  constructor(
    @Inject('AuthService') private authService: AuthStrategy,
    @Inject('TokenService') private readonly tokenService: TokenStrategy,
  ) {}

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

  @Get('me')
  getUser(@Req() req: Request): Promise<UserResponseDto> {
    const header = req.headers['authorization'] as string;
    if (header === undefined) throw new HttpException('Token is invalid', HttpStatus.UNAUTHORIZED);

    const token = header.split(' ')[1];

    return this.authService.getUser(this.tokenService.decodeToken(token));
  }
}
