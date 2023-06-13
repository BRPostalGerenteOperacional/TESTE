import { Injectable } from '@nestjs/common'
import { user_categories } from '@prisma/client'
import serializeBigInt from 'src/utils/serializeBigInt'
import { PrismaService } from '../prisma/service'

@Injectable()
export class CategoriesService {
  constructor(private readonly prisma: PrismaService) {}
  async findAll(): Promise<user_categories[]> {
    const categories = await this.prisma.user_categories.findMany()

    return serializeBigInt(categories) as user_categories[]
  }
}
