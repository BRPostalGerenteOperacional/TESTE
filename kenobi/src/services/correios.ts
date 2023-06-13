import { Logger } from '@nestjs/common'
import axios from 'axios'

const logger = new Logger('Correios')

export const correiosProxy = axios.create({
  baseURL: 'https://proxyapp.correios.com.br/v1',
})

export interface CorreiosUserDataDTO {
  ambiente: 'HOMOLOGACAO' | 'PRODUCAO'
  id: string
  perfil: 'PJ'
  cnpj: string
  cartaoPostagem: {
    numero: string
    contrato: string
    dr: number
    api: number[]
  }
  ip: string
  emissao: string
  expiraEm: string
  zoneOffset: string
  token: string
  expiresHour: string | number
  expiresMin: string | number
}

export const correios = axios.create({
  baseURL: process.env.CORREIOS_API_URL,
})

export const correiosEndPoints = {
  token: 'token/v1',
  cep: 'cep/v1',
  rastro: 'srorastro/v1',
}

export let correiosUserData = {
  expiresHour: new Date().getHours(),
  expiresMin: new Date().getMinutes(),
} as CorreiosUserDataDTO

export function updateCorreiosUserData(newData: CorreiosUserDataDTO) {
  const splittedTime = newData.expiraEm.split('T')[1]

  const tokenExpiresHour = splittedTime.split(':')[0]
  const tokenExpiresMinutes = splittedTime.split(':')[1]

  correiosUserData = {
    ...newData,
    expiresHour: tokenExpiresHour,
    expiresMin: tokenExpiresMinutes,
  }
}

export function getCorreiosUserData() {
  correios
    .post(
      `${correiosEndPoints.token}/autentica/cartaopostagem`,
      {
        numero: process.env.CORREIOS_POSTCARD,
      },
      {
        auth: {
          username: process.env.CORREIOS_USERNAME,
          password: process.env.CORREIOS_PASSWORD,
        },
      }
    )
    .then(response => {
      updateCorreiosUserData(response.data as CorreiosUserDataDTO)
    })
    .catch(error => {
      logger.error('Tivemos um erro com a API dos Correios')
      logger.log({ status: error.response.status, data: error.response.data })
    })
}

getCorreiosUserData()
