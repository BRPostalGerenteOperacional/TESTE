import { Controller, Get } from '@nestjs/common'
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger'
import { admins } from '@prisma/client'

import { AdminsService } from './service'

@ApiTags('admins')
@Controller('admins')
export class AdminsController {
  constructor(private readonly adminsService: AdminsService) {}

  @ApiOperation({ summary: 'Buscar todos os admins' })
  @ApiResponse({
    status: 200,
    description: 'Admins encontrados',
    isArray: true,
  })
  @Get()
  findAll(): Promise<admins[]> {
    return this.adminsService.findAll()
  }
}
