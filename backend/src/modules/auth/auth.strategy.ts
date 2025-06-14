import { UserRequestDto, UserResponseDto } from 'src/models/http/user-dto';

export interface AuthStrategy {
  signIn(user: UserRequestDto): Promise<UserResponseDto>;

  signUp(user: UserRequestDto): Promise<UserResponseDto>;
}
