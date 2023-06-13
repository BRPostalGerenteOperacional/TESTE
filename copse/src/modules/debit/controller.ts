import * as NestCommon from '@nestjs/common'
import { Prisma, WalletDebit } from '@prisma/client'
import { CreateDebitDTO } from './dto/CreateDebit.dto'

import { DebitService } from './service'

@NestCommon.Controller('/debit')
export class DebitController {
  constructor(private readonly debitService: DebitService) { }

  @NestCommon.Post()
  create(@NestCommon.Body() transactionData: CreateDebitDTO): Promise<WalletDebit> {
    return this.debitService.create(transactionData)
  }

  @NestCommon.Delete('/:id')
  @NestCommon.HttpCode(204)
  async delete(@NestCommon.Param('id') id: string) {
    return await this.debitService.delete(id)
  }

  @NestCommon.Put(':id')
  async update(
    @NestCommon.Param('id') id: string,
    @NestCommon.Body() updateData: Prisma.WalletDebitUpdateInput
  ) {
    return await this.debitService.update(id, updateData)
  }
}
