import { Logger } from '@nestjs/common'
import axios from 'axios'

const logger = new Logger('Brasil APIs')

export const IntegrationBrasil = axios.create({
  baseURL: process.env.BRASIL_API_URL,
})

export const BrasilEndPoints = {
  cepv2: '/cep/v2/',
  cepv1: '/cep/v1/',
}
