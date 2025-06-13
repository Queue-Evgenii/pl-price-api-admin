import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from 'src/guards/auth.guard';

@Controller('categories')
export class CategoriesController {
  @Get()
  @UseGuards(AuthGuard)
  getCategories() {
    return 'works 1';
  }
}
