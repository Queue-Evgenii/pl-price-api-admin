import { UserRequestDto, UserResponseDto } from 'src/models/http/user-dto';
import { TokenPayload } from 'src/models/token-payload';

export interface AuthStrategy {
  signIn(user: UserRequestDto): Promise<UserResponseDto>;

  signUp(user: UserRequestDto): Promise<UserResponseDto>;

  getUser(payload: TokenPayload): Promise<UserResponseDto>;
}
