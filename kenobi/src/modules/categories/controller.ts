import { Controller, Get } from '@nestjs/common'
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'
import { CategoriesService } from './service'

@ApiTags('categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @ApiOperation({ summary: 'Buscar todas as categorias e usuários' })
  @ApiResponse({
    status: 200,
    description: 'Categorias encontradas',
    isArray: true,
  })
  @Get()
  findAll() {
    return this.categoriesService.findAll()
  }
}
