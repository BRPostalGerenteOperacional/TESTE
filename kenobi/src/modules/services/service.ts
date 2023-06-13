import { Injectable } from '@nestjs/common'
import { services } from '@prisma/client'

import serializeBigInt from 'src/utils/serializeBigInt'
import { PrismaService } from '../prisma/service'

@Injectable()
export class ServicesService {
  constructor(private readonly prisma: PrismaService) {}
  async findAll(): Promise<services[]> {
    const services = await this.prisma.services.findMany()

    return serializeBigInt(services) as services[]
  }
}
