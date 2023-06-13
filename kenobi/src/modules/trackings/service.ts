import { BadRequestException, Injectable, NotFoundException, Logger, ConsoleLogger } from '@nestjs/common'

import { correios, correiosEndPoints, correiosUserData } from 'src/services/correios'
import { ObjetoTrackDTO } from './dto/CorreiosTrack.dto'

import { jtIntegration, jtIntegrationDate, JTEndPoints } from 'src/services/jtexpress'
import { TrackDTO } from './dto/Track.dto'

const logger = new Logger('Trackings')
@Injectable()
export class TrackingsService {
  async trackingCorreiosObject(
    objectId: string,
    evento: 'T' | 'P' | 'U'
  ): Promise<ObjetoTrackDTO | NotFoundException> {
    try {
      const { data } = await correios.get(
        `${correiosEndPoints.rastro}/objetos/${objectId}`,
        {
          params: {
            resultado: evento,
          },
          headers: {
            Authorization: `Bearer ${correiosUserData.token}`,
          },
        }
      )

      const object = data.objetos[0]

      if (object.mensagem && object.mensagem.includes('SRO-020')) {
        throw new NotFoundException('Objeto não encontrado')
      }

      return object
    } catch (error) {
      throw new BadRequestException('Verifique se enviou os dados corretos')
    }
  }
  async trackingJTObject(
    objectId: string,
  ): Promise<TrackDTO | NotFoundException> {
    try {
      const body = {
        tags: [{ tag: `${objectId}`,}]
      };

      const { data } :any= await jtIntegration.post(`${JTEndPoints.trace}`, body, {
        headers: {
          Authorization: `Bearer ${jtIntegrationDate.token}`,
        },
      }).catch(error=>console.log(error));

      if (!Array.isArray(data.object) || !data.object[0].tag || !Array.isArray(data.object[0].tracking)) {
        throw new Error("Formato de objeto inválido");
      }

      const answer = data.answer[0];
      const object = data.object[0];

      if ((!object) && (answer.mensagem!=='sucess'))
      {
        throw new NotFoundException(answer.mensagem);
      }

      const eventos = object.tracking.map((item) => (
      {
        tipo: item.type,
        dtHrCriado: new Date(item.updateData),
        descricao: item.detail.replace(/[^a-zA-Z0-9]/g,' ').replace('         ',' '),
      }));

      const result: TrackDTO = {
        codObjeto: object.tag,
        eventos,
      };

      return result;
    } catch (error) {
      throw new BadRequestException("Verifique se enviou os dados corretos");
    }
  }
}
