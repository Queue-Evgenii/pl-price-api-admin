import { ApiProperty } from '@nestjs/swagger';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn, Tree, TreeChildren, TreeParent } from 'typeorm';
import { BaseEntity } from './base.entity';
import { PhotoEntity } from './photo.entity';
import { Expose } from 'class-transformer';

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

  @Column({ nullable: false })
  @ApiProperty()
  orderId: number;

  @TreeParent()
  @ApiProperty()
  parent: CategoryEntity | null;

  @TreeChildren()
  @ApiProperty()
  children: CategoryEntity[];

  @OneToMany(() => PhotoEntity, (photo) => photo.category)
  @ApiProperty({ type: () => [PhotoEntity] })
  photos: PhotoEntity[];

  @Expose()
  countPhotos: number = 0;
}
