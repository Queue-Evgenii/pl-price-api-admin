import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { CategoryEntity } from './category.entity';

@Entity()
export class SiteEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ unique: true })
  @ApiProperty()
  code: string;

  @Column({ nullable: true })
  @ApiProperty()
  name: string;

  @Column({ type: 'boolean', default: false })
  @ApiProperty()
  active: boolean

  @OneToMany(() => CategoryEntity, (category) => category.site)
  @ApiProperty({ type: () => [CategoryEntity] })
  categories: CategoryEntity[];
}
