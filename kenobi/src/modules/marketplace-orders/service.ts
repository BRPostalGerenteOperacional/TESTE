import { Injectable } from '@nestjs/common'

import { PrismaService } from '../prisma/service'
import { CreateMarketplaceOrderDTO } from './dto/CreateMarketplaceShipment.dto'

interface OrderShipments {
  marketplace_name: string
  tracking_id: string
  to_zip_code?: string
  marketplace_order_id: number | bigint
  created_at: Date
  updated_at: Date
}

@Injectable()
export class MarketplaceOrdersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: CreateMarketplaceOrderDTO) {
    const createdOrder = await this.prisma.marketplace_orders.create({
      data: {
        objects_quantity: String(data.shipments.length),
        user_id: data.user_id,
        created_at: new Date(),
        updated_at: new Date(),
      },
    })

    const withOrderShipments = data.shipments.map((shipment): OrderShipments => {
      return {
        ...shipment,
        marketplace_order_id: Number(createdOrder.id),
        created_at: new Date(),
        updated_at: new Date(),
      }
    })

    await this.prisma.marketplace_shipments.createMany({
      data: withOrderShipments,
    })

    const order = await this.prisma.marketplace_orders.findUnique({
      where: {
        id: Number(createdOrder.id),
      },
      include: {
        marketplace_shipments: true,
      },
    })

    return JSON.stringify(order, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )
  }

  async findAllByUser(user_id: number) {
    const orders = await this.prisma.marketplace_orders.findMany({
      where: {
        user_id,
      },
    })

    return JSON.stringify(orders, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )
  }

  async findOne(id: number) {
    const order = await this.prisma.marketplace_orders.findUnique({
      where: {
        id: id,
      },
      select: {
        marketplace_shipments: true,
        objects_quantity: true,
        user_id: true,
        id: true,
        created_at: true,
      },
    })

    return JSON.stringify(order, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )
  }
}
