import { BadRequestException, Injectable, Logger } from '@nestjs/common'
import { Cron } from '@nestjs/schedule'
import {
  correios,
  correiosEndPoints,
  correiosUserData,
  getCorreiosUserData,
} from 'src/services/correios'
import { AddressResponseDTO } from './dto/AddressResponse.dto'

import { BrasilEndPoints, IntegrationBrasil } from 'src/services/brasilapi'
import { da } from 'date-fns/locale'

const cronMin = correiosUserData.expiresMin
const cronHour = correiosUserData.expiresHour

@Injectable()
export class AddressService {
  private readonly logger = new Logger(AddressService.name)

  @Cron(`0 ${cronMin} ${cronHour} * * *`)
  handlecron() {
    this.logger.debug('Regenerate Correios access token')

    getCorreiosUserData()

    this.logger.log(`Token será expirado em ${correiosUserData.expiraEm}`)
  }

  async findByCEP(cep: string): Promise<AddressResponseDTO | BadRequestException> {
    try {
      const { data } = await correios.get(`${correiosEndPoints.cep}/enderecos/${cep}`, {
        headers: {
          Authorization: `Bearer ${correiosUserData.token}`,
        },
      })

      throw new Error("Formato de objeto inválido");

      return data
    } catch (error) {
      this.logger.log('Tivemos um erro com a API dos Correios - CEP');
      this.logger.log(error);
      return this.findByCepBrasilAPI(cep)
    }
  }

  async findByCepBrasilAPI(cep: string): Promise<AddressResponseDTO | BadRequestException> {
    try {
      const { data } = await IntegrationBrasil.get(`${BrasilEndPoints.cepv2}${cep}`)

      if (!data)
      {
        throw new Error("Formato de objeto inválido");
      }

      const result: AddressResponseDTO = {
        bairro: data.neighborhood,
        cep: data.cep,
        cepUnidadeOperacional: data.cep,
        clique: null,
        localidade: data.city,
        localidadeSuperior: data.city,
        logradouro: data.street,
        nomeLogradouro: data.state,
        numeroLocalidade: null,
        tipoCEP: data.services,
        tipoLogradouro: data.location.type,
        uf: data.state,
      };

      return result;
    } catch (error) {
      throw new BadRequestException()
    }
  }
}
