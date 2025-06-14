import { Exclude } from 'class-transformer';
import { UserRoles } from 'src/models/roles';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class UserEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Exclude()
  @Column({ nullable: false })
  password: string;

  @Column({ nullable: true })
  name: string;

  @Column({
    type: 'enum',
    enum: UserRoles,
    default: [UserRoles.DEFAULT],
  })
  roles: UserRoles;
}
