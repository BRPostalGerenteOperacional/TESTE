import { Injectable, Logger } from '@nestjs/common'
import { Cron } from '@nestjs/schedule'
import { shipments } from '@prisma/client'

import { copse } from 'src/services/copse'
import { PrismaService } from '../prisma/service'

import getPlpData from './data/correios'
import { CorreiosPLPDimensionsDTO } from './dto/CorreiosPlpData.dto'
import GetRateDTO from './dto/GetRate.dto'
import UpdateRecalculatedShipmentDTO from './dto/UpdateRecalculatedShipment.dto'
import UpdateUserBalanceDTO from './dto/UpdateUserBalance.dto'
import GetTrackingObjectDTO, {
  ResponseTrackingObjectDTO,
} from './dto/GetTrackingObject.dto'

interface ExternalData {
  idPlp?: string
  volume?: object
}

@Injectable()
export class ShipmentsService {
  private readonly logger = new Logger(ShipmentsService.name)
  constructor(private readonly prisma: PrismaService) {}

  @Cron('*/15 * * * *')
  async handleCron() {
    const unsentShipments = await this.prisma.shipments.findMany({
      where: {
        shipped_at: null,
        external_id: {
          not: null,
        },
      },
    })

    this.logger.debug('Running recalculateShipment')

    unsentShipments.forEach(async shipment => {
      await this.recalculateShipment(shipment)
    })
  }

  async recalculateShipment(shipment: shipments) {
    const shipmentExternalData = shipment.external_data as ExternalData

    const trackingData = await this.getTrackingObject({
      externalId: shipment.external_id,
      externalData: shipmentExternalData,
      shipment: shipment,
    })

    if (trackingData.getRateObject) {
      const rate = await this.getRate(trackingData.getRateObject)
      let shipmentAmount = String(shipment.amount)

      if (!rate) return

      if (rate.absolute_money_cost > shipment.amount) {
        const gapBetweenAmounts = rate.absolute_money_cost - shipment.amount

        await this.addUserDebit({
          newAmount: gapBetweenAmounts.toFixed(2),
          orderId: Number(shipment.order_id),
          userId: Number(shipment.user_id),
        })

        shipmentAmount = rate.absolute_money_cost.toFixed(2)
      }

      if (rate.absolute_money_cost < shipment.amount) {
        const gapBetweenAmounts = shipment.amount - rate.absolute_money_cost

        await this.addUserCredit({
          newAmount: gapBetweenAmounts.toFixed(2),
          orderId: Number(shipment.order_id),
          userId: Number(shipment.user_id),
        })

        shipmentAmount = rate.absolute_money_cost.toFixed(2)
      }

      setTimeout(async () => {
        await this.updateRecalculatedShipment({
          objectData: trackingData.trackingData,
          newAmount: Number(shipmentAmount),
          shipmentId: Number(shipment.id),
          shippedAt: new Date(),
          orderId: Number(shipment.order_id),
        })
      }, 1000)

      this.logger.warn(
        `Total do shipment ${shipment.id} será alterado para ${shipmentAmount}`
      )
    }
  }

  async getTrackingObject({
    externalData,
    shipment,
  }: GetTrackingObjectDTO): Promise<ResponseTrackingObjectDTO> {
    let trackingObject = {
      trackingData: null,
      getRateObject: null,
      shippedAt: null,
    }

    if (externalData.idPlp) {
      const correiosPlpData = await getPlpData(externalData.idPlp)

      if (correiosPlpData) {
        const splittedDate = correiosPlpData.captureData.split('/')
        const splittedYearAndHour = splittedDate[2].split(' ')
        const splittedHour = splittedYearAndHour[1].split(':')

        const shippedAt = new Date(
          Number(splittedYearAndHour[0]),
          Number(splittedDate[1]),
          Number(splittedDate[0]),
          Number(splittedHour[0]),
          Number(splittedHour[1]),
          Number(splittedHour[2])
        )

        if (correiosPlpData) {
          trackingObject = {
            trackingData: {
              width: correiosPlpData.dimensions.width,
              height: correiosPlpData.dimensions.height,
              length: correiosPlpData.dimensions.length,
              weight: correiosPlpData.weight,
            },
            getRateObject: {
              fromState: correiosPlpData.senderUf,
              fromZipCode: correiosPlpData.senderZipCode,
              toZipCode: correiosPlpData.recipientZipCode,
              weight: Number(correiosPlpData.weight),
              serviceId: Number(shipment.service_id),
            } as GetRateDTO,
            shippedAt,
          }
        }
      }
    }

    return trackingObject
  }

  async addUserDebit({ userId, newAmount, orderId }: UpdateUserBalanceDTO) {
    try {
      const userWallet = await copse.get(`/wallet/${userId}`)

      await copse.post('/debit', {
        quantity: newAmount,
        laravelOrderId: orderId,
        walletId: userWallet.data.id,
        observation: `Gap between inputed and real data on order ${orderId}`,
        debitOption: 'OrderCorrection',
      })
    } catch (error) {
      console.log(error)
    }
  }

  async addUserCredit({ userId, newAmount, orderId }: UpdateUserBalanceDTO) {
    try {
      const userWallet = await copse.get(`/wallet/${userId}`)

      await copse.post('/credit', {
        quantity: newAmount,
        walletId: userWallet.data.id,
        paymentOption: 'Estorno',
        payedAt: new Date(),
        observation: `Gap between inputed and real data on order ${orderId}`,
      })
    } catch (error) {
      console.log(error)
      return
    }
  }

  async updateRecalculatedShipment({
    objectData,
    shipmentId,
    newAmount,
    shippedAt,
    orderId,
  }: UpdateRecalculatedShipmentDTO) {
    try {
      const order = await this.prisma.orders.findUnique({
        where: { id: orderId },
        include: {
          shipments: {
            where: {
              id: {
                not: shipmentId,
              },
            },
          },
        },
      })

      let orderAmount = newAmount

      order.shipments.map(shipment => {
        orderAmount += shipment.amount
      })

      await this.prisma.shipments.update({
        where: {
          id: shipmentId,
        },
        data: {
          shipped_at: shippedAt,
          amount: newAmount,
          width: Number(objectData.width),
          height: Number(objectData.height),
          length: Number(objectData.length),
          weight: Number(objectData.weight) / 1000,
          orders: {
            update: {
              amount: orderAmount,
            },
          },
        },
      })
    } catch (erro) {
      this.logger.error(erro)
    }
  }

  getCubicWeight(dimensions: CorreiosPLPDimensionsDTO, peso: number) {
    const volume =
      Number(dimensions.width) * Number(dimensions.height) * Number(dimensions.length)

    const cubicWeight = volume / 6000

    const cWeightInG = cubicWeight * 1000
    let weightPrevalent = peso

    if (cubicWeight > peso) {
      weightPrevalent = cWeightInG
    }

    const total_pac =
      Number(dimensions.width) + Number(dimensions.height) + Number(dimensions.length)

    if (weightPrevalent > 30000 || total_pac > 200) {
      return null
    }

    return cubicWeight
  }

  async getRate({ fromState, toZipCode, weight, serviceId }: GetRateDTO) {
    return await this.prisma.rates.findFirst({
      where: {
        rate_files: {
          state: fromState,
          service_id: serviceId,
        },
        weight_start: {
          lte: weight,
        },
        weight_end: {
          gte: weight,
        },
        zipcode_start: {
          lte: String(toZipCode),
        },
        zipcode_end: {
          gte: String(toZipCode),
        },
      },
      select: {
        zipcode_end: true,
        zipcode_start: true,
        absolute_money_cost: true,
      },
    })
  }
}
