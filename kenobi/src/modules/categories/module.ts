import { Module } from '@nestjs/common'
import { CategoriesService } from './service'
import { CategoriesController } from './controller'
import { PrismaModule } from '../prisma/module'

@Module({
  imports: [PrismaModule],
  controllers: [CategoriesController],
  providers: [CategoriesService],
})
export class CategoriesModule {}
