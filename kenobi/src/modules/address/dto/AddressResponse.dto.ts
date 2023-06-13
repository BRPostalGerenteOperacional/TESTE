import { ApiProperty } from '@nestjs/swagger'

export class AddressResponseDTO {
  @ApiProperty({ example: '01310932' })
  cep: string

  @ApiProperty({ example: 'SP' })
  uf: string

  @ApiProperty({ example: 'São Paulo' })
  localidade: string

  @ApiProperty({ example: 'Avenida Paulista, 2202' })
  logradouro: string

  @ApiProperty({ example: 'Avenida' })
  tipoLogradouro: string

  @ApiProperty({ example: 'Paulista' })
  nomeLogradouro: string

  @ApiProperty({ example: '2202', required: false })
  numeroLogradouro?: string

  @ApiProperty({ example: undefined, required: false })
  abreviatura?: string

  @ApiProperty({ example: 'Bela Vista' })
  bairro: string

  @ApiProperty({ example: 96681 })
  numeroLocalidade: number

  @ApiProperty({ example: undefined, required: false })
  numeroLocalidadeSuperior?: number

  @ApiProperty({ example: 'São Paulo', description: 'Não é o estado' })
  localidadeSuperior: string

  @ApiProperty({ example: undefined, required: false })
  sigleUnidade?: string

  @ApiProperty({ example: 5 })
  tipoCEP: number

  @ApiProperty({ example: undefined, required: false })
  cepAnterior?: string

  @ApiProperty({
    example: '05312976',
    description: 'CEP da Unidade Correios mais próxima',
  })
  cepUnidadeOperacional: string

  @ApiProperty({ example: 'P', required: false })
  lado?: string

  @ApiProperty({ example: '2202', required: false })
  numeroInicial?: number

  @ApiProperty({ example: '2202', required: false })
  numeroFinal?: number

  @ApiProperty({ example: 'N' })
  clique: string

  @ApiProperty({ example: undefined, required: false })
  txMsg?: string
}
