import type { AxiosInstance } from "axios";
import { Api } from "../api";
import type { UserDto } from "@/types/models/dto/user-dto";
import type { UserEntity } from "@/types/models/entities/user.entity";

export class AuthApi extends Api {
  constructor(apiClient: AxiosInstance) {
    super(apiClient, '/auth');
  }

  authorization = (payload: Partial<UserEntity>) => {
    return this.postRequest<UserDto, Partial<UserEntity>>('/sign-in', payload);
  };

  registration = (payload: UserEntity) => {
    console.warn("NOT IMPLEMENTED");
    throw Error("NOT IMPLEMENTED");
  };
}