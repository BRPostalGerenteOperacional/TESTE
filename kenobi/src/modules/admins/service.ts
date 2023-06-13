import { Injectable } from '@nestjs/common'
import { admins } from '@prisma/client'
import { PrismaService } from 'src/modules/prisma/service'
import serializeBigInt from 'src/utils/serializeBigInt'

@Injectable()
export class AdminsService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(): Promise<admins[]> {
    const admins = await this.prisma.admins.findMany()
    return serializeBigInt(admins) as admins[]
  }
}
