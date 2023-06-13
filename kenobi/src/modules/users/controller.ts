import { Controller, Get } from '@nestjs/common'
import { ApiOperation, ApiTags } from '@nestjs/swagger'
import { UsersService } from './service'

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @ApiOperation({ summary: 'Obter todos os usuário balcões' })
  @Get('counters')
  getAllCounters() {
    return this.usersService.getAllCounteUsers()
  }
}
