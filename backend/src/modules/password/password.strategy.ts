export interface PasswordStrategy {
  hash(password: string): Promise<string>;

  compare(givenPassword: string, originPassword: string): Promise<boolean>;
}
