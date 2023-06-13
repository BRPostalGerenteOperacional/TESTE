import { Injectable } from '@nestjs/common'
import { PrismaService } from '../prisma/service'

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async getAllCounteUsers() {
    const counters = await this.prisma.users.findMany({
      where: {
        role: 'counter',
      },
    })

    return JSON.stringify(counters, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )
  }
}
