import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn, Tree, TreeChildren, TreeParent } from 'typeorm';
import { BaseEntity } from './base.entity';
import { PhotoEntity } from './photo.entity';

@Entity()
@Tree('closure-table')
export class CategoryEntity extends BaseEntity {
  @PrimaryGeneratedColumn()
  @ApiProperty()
  id: number;

  @Column({ type: 'varchar', length: 255 })
  @ApiProperty()
  name: string;

  @Column({ type: 'varchar', length: 255, unique: true })
  @ApiProperty()
  slug: string;

  @TreeParent()
  @ApiProperty()
  parent: CategoryEntity | null;

  @TreeChildren()
  @ApiProperty()
  children: CategoryEntity[];

  @OneToMany(() => PhotoEntity, (photo) => photo.category)
  @ApiProperty({ type: () => [PhotoEntity] })
  photos: PhotoEntity[];
}
