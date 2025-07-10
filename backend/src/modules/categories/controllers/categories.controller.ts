import { Body, Controller, Get, Inject, Param, ParseIntPipe, Query, UsePipes, ValidationPipe } from '@nestjs/common';
import { FindAllCategoriesOptionsDto } from 'src/models/http/category-dto';
import { ApiFindAllResponses, ApiFindOneResponses } from 'src/decorators/categories.decorator';
import { CategoriesStrategy } from '../services/categories.strategy';

@Controller('categories')
export class CategoriesController {
  constructor(@Inject('CategoriesService') private categoriesService: CategoriesStrategy) {}

  @Get()
  @ApiFindAllResponses()
  @UsePipes(new ValidationPipe({ transform: true }))
  findAll(@Query() query: FindAllCategoriesOptionsDto) {
    return this.categoriesService.findAll(query);
  }

  @Get(':id')
  @ApiFindOneResponses()
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.categoriesService.findOne(id);
  }
}
