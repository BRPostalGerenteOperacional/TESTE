import { ApiProperty } from '@nestjs/swagger'

class TipoPostal {
  @ApiProperty({ maxLength: 2 })
  sigla: string

  @ApiProperty({ maxLength: 40 })
  nome: string

  @ApiProperty({ maxLength: 30 })
  categoria: string
}

class Recebedor {
  @ApiProperty({ maxLength: 72 })
  nome: string

  @ApiProperty({ maxLength: 25 })
  documento: string

  @ApiProperty({ maxLength: 13 })
  celular: string

  @ApiProperty({ maxLength: 60 })
  email: string

  @ApiProperty({ maxLength: 50 })
  comentario: string
}

class Endereco {
  @ApiProperty({ maxLength: 8 })
  cep: string

  @ApiProperty({ maxLength: 80 })
  logradouro: string

  @ApiProperty({ maxLength: 60 })
  complemento: string

  @ApiProperty({ maxLength: 12 })
  numero: string

  @ApiProperty({ maxLength: 60 })
  bairro: string

  @ApiProperty({ maxLength: 2, description: 'Estado' })
  uf: string

  @ApiProperty({ maxLength: 13 })
  telefone: string

  @ApiProperty({ maxLength: 60 })
  cidade: string
}

class Unidade {
  @ApiProperty({ maxLength: 40 })
  nome: string

  @ApiProperty({ maxLength: 8 })
  codSro: string

  @ApiProperty({ maxLength: 12 })
  codMcu: string

  @ApiProperty({ maxLength: 2 })
  tipo: string

  @ApiProperty({ type: Endereco, name: 'Endereço' })
  endereco: Endereco
}

class Entregador {
  @ApiProperty({ title: 'CPF', maxLength: 15 })
  documento: string

  @ApiProperty({ maxLength: 80 })
  nome: string
}

class Telefone {
  @ApiProperty({ maxLength: 4, enum: ['CEL', 'FIXO', 'Celular (Cel)'] })
  tipo: 'CEL' | 'FIXO' | 'Celular (Cel)'

  @ApiProperty({ maxLength: 2 })
  ddd: string

  @ApiProperty({ maxLength: 11 })
  numero: string
}

class Destinatario {
  @ApiProperty({ maxLength: 80 })
  nome: string

  @ApiProperty({ maxLength: 25 })
  documento: string

  @ApiProperty({ maxLength: 60 })
  email: string

  @ApiProperty({ type: Telefone, name: 'Telefones' })
  telefones: Telefone[]

  @ApiProperty({
    type: Endereco,
    name: 'Endereço',
    description:
      'Classe que representa um endereço. Para os eventos do tipo Lançamento, o endereço para as unidades será exibido completamente. Nos demais casos, será exibido apenas cidade e uf.',
  })
  endereco: Endereco
}

class Evento {
  codigo: string

  tipo: string

  dtHrCriado: Date

  descricao: string

  detalhe: string

  @ApiProperty({ type: Recebedor, name: 'Recebedor' })
  recebedor: Recebedor

  @ApiProperty({ type: Unidade, name: 'Unidae de Tratamento' })
  unidade: Unidade

  @ApiProperty({ type: Entregador, name: 'Entregador externo' })
  etregdorExterno: Entregador

  @ApiProperty({ type: Destinatario, name: 'Destinatário' })
  destinatario: Destinatario

  @ApiProperty({ maxLength: 100 })
  comentario: string

  @ApiProperty({ type: Unidade })
  unidadeDestino: Unidade
}

export class ObjetoTrackDTO {
  @ApiProperty({ maxLength: 12 })
  codObjeto: string

  @ApiProperty({ type: TipoPostal })
  tipoPostal: TipoPostal

  @ApiProperty({ type: Date })
  dtPrevista: string

  @ApiProperty()
  modalidade: string

  @ApiProperty({ type: Number, maxLength: 10, description: 'Peso do objeto em gramas' })
  peso: number

  @ApiProperty({ maxLength: 40 })
  formato: string

  @ApiProperty({ type: Evento })
  evetos: Evento[]
}
