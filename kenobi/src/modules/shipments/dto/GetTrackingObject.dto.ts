import { shipments } from '@prisma/client'

import GetRateDTO from './GetRate.dto'

export default interface GetTrackingObjectDTO {
  externalId: string
  externalData: {
    idPlp?: string
    volume?: object
  }
  shipment: shipments
}

export type ResponseTrackingObjectDTO = {
  trackingData: {
    width: number
    height: number
    length: number
    weight: number
  }
  getRateObject: GetRateDTO | null
  shippedAt: Date
}

export interface JadLogPlpData {
  codigo: string
  shipmentId: string
  dtEmissao: string
  status: string
  valor: number
  peso: number
  eventos: [{ data: string; status: string; unidade?: string }]
  volumes: [{ peso: number; altura: number; largura: number; comprimento: number }]
}
