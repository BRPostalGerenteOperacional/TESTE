import { Controller, Get, Param } from '@nestjs/common'
import { ApiOperation, ApiParam, ApiResponse, ApiTags } from '@nestjs/swagger'
import { AddressResponseDTO } from './dto/AddressResponse.dto'
import { AddressService } from './service'

@ApiTags('address')
@Controller('address')
export class AddressController {
  constructor(private readonly addressService: AddressService) {}

  @ApiOperation({ summary: 'Encontrar endereço pelo CEP' })
  @ApiResponse({
    status: 400,
    description: 'Requisição incorreta. CEP deve conter apensar números',
  })
  @ApiResponse({
    status: 200,
    description: 'Endereço encontrado e mostrado',
    type: AddressResponseDTO,
  })
  @ApiParam({
    name: 'cep',
    example: '01310932',
    type: 'string',
    description: 'Apenas números, sem hífen',
  })
  @Get(':cep')
  findOne(@Param('cep') cep: string) {
    return this.addressService.findByCEP(cep)
  }
}
