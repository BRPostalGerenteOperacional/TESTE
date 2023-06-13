import { ApiProperty } from '@nestjs/swagger'

class Evento {
  codigo: string

  tipo: string

  dtHrCriado: Date

  descricao: string

}

export class TrackDTO {
  @ApiProperty({ maxLength: 12 })
  codObjeto: string

  @ApiProperty({ type: Evento })
  eventos: Evento[]
}
