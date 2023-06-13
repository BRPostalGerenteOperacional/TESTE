import { Injectable, NotFoundException } from '@nestjs/common'
import { format } from 'date-fns'

import { PrismaService } from '../prisma/service'
import { CreateCounterReportDto, OrdersDataDTO } from './dto/create-counter-report.dto'

@Injectable()
export class CounterReportService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: CreateCounterReportDto) {
    let orderData = []
    let csv = ''

    const prismaFilter = {
      user_id: Number(data.counter_id),
      created_at: {
        gte: new Date(`${data.year}-${data.month}-01T14:21:00+0200`),
        lte: new Date(`${data.year}-${data.month}-31T14:21:00+0200`),
      },
    }

    if (data.order_type === 'marketplace') {
      orderData = await this.prisma.marketplace_orders.findMany({
        where: prismaFilter,
        include: {
          marketplace_shipments: true,
        },
      })

      csv = await this.transformMarketplaceOrdersToXSLS(orderData as OrdersDataDTO[])
    }

    if (data.order_type === 'standard') {
      orderData = await this.prisma.orders.findMany({
        where: prismaFilter,
        include: {
          shipments: true,
        },
      })

      csv = await this.transformStandardOrderToXSLX(orderData as OrdersDataDTO[])
    }

    if (orderData.length === 0) {
      throw new NotFoundException('Something not found!')
    }

    const serializedData = JSON.stringify(orderData, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )

    return {
      orders: JSON.parse(serializedData),
      csv,
    }
  }

  async transformStandardOrderToXSLX(orders: OrdersDataDTO[]) {
    const data = [['Pedido', 'Balcão', 'Envio', 'Valor', 'Peso', 'Rastreio', 'Data']]

    orders.map(order => {
      order.shipments.map(shipment => {
        data.push([
          String(order.id),
          String(order.user_id),
          String(shipment.id),
          String(shipment.amount),
          `${shipment.weight}kg`,
          shipment.external_id || 'N/A',
          format(shipment.created_at, 'dd/MM/yyyy'),
        ])
      })
    })

    return await this.generateCSV(data)
  }

  async transformMarketplaceOrdersToXSLS(orders: OrdersDataDTO[]) {
    const data = [
      ['Pedido', 'Balcão', 'Envio', 'Marketplace', 'Rastreio', 'CEP Destino', 'Data'],
    ]

    orders.map(order => {
      order.marketplace_shipments.map(shipment => {
        data.push([
          String(order.id),
          String(order.user_id),
          String(shipment.id),
          String(shipment.marketplace_name),
          String(shipment.tracking_id),
          shipment.to_zip_code || 'N/A',
          format(shipment.created_at, 'dd/MM/yyyy'),
        ])
      })
    })

    return await this.generateCSV(data)
  }

  async generateCSV(data: string[][]) {
    let csvContent = 'data:text/csv;charset=utf-8,'

    data.forEach(function (rowArray: string[]) {
      const row = rowArray.join(',')
      csvContent += row + '\r\n'
    })

    return encodeURI(csvContent)
  }
}
