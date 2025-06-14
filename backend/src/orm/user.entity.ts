import { ApiProperty } from '@nestjs/swagger';
import { Exclude } from 'class-transformer';
import { UserRoles } from 'src/models/roles';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class UserEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ unique: true })
  @ApiProperty()
  email: string;

  @Exclude()
  @Column({ nullable: false })
  password: string;

  @Column({ nullable: true })
  @ApiProperty()
  name: string;

  @Column({
    type: 'enum',
    enum: UserRoles,
    default: [UserRoles.DEFAULT],
  })
  @ApiProperty()
  roles: UserRoles;
}
