import { Body, Controller, Delete, Get, Inject, Param, ParseIntPipe, Patch, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';
import { CreateCategoryRequestDto, UpdateCategoryRequestDto } from 'src/models/http/category-dto';
import { CategoriesStrategy } from './categories.strategy';
import { ApiCreateResponses, ApiFindAllResponses, ApiFindOneResponses, ApiRemoveResponses, ApiUpdateResponses } from 'src/decorators/categories.decorator';

@Controller('categories')
@UseGuards(AuthGuard)
export class CategoriesController {
  constructor(@Inject('CategoriesService') private categoriesService: CategoriesStrategy) {}

  @Post()
  @ApiCreateResponses()
  create(@Body() dto: CreateCategoryRequestDto) {
    return this.categoriesService.create(dto);
  }

  @Get()
  @ApiFindAllResponses()
  findAll() {
    return this.categoriesService.findAll();
  }

  @Get(':id')
  @ApiFindOneResponses()
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.findOne(id);
  }

  @Patch(':id')
  @ApiUpdateResponses()
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateCategoryRequestDto) {
    return this.categoriesService.update(id, dto);
  }

  @Delete(':id')
  @ApiRemoveResponses()
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.remove(id);
  }
}
