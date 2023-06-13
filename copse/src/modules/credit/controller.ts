import * as NestCommon from '@nestjs/common'
import { Prisma, WalletCredit } from '@prisma/client'
import { CreateCreditDTO } from './dto/CreateCredit.dto'
import { CreateRefundDTO } from './dto/CreateRefund.dto'

import { CreditService } from './service'

@NestCommon.Controller('/credit')
export class CreditController {
  constructor(private readonly creditService: CreditService) {}

  @NestCommon.Post()
  create(@NestCommon.Body() creditData: CreateCreditDTO): Promise<WalletCredit> {
    return this.creditService.create(creditData)
  }

  @NestCommon.Post('/refund')
  createRefund(@NestCommon.Body() refundData: CreateRefundDTO): Promise<WalletCredit> {
    return this.creditService.createRefund(refundData)
  }

  @NestCommon.Delete('/:id')
  @NestCommon.HttpCode(204)
  async delete(@NestCommon.Param('id') id: string) {
    return await this.creditService.delete(id)
  }

  @NestCommon.Put(':id')
  async update(
    @NestCommon.Param('id') id: string,
    @NestCommon.Body() updateData: Prisma.WalletCreditUpdateInput
  ) {
    return await this.creditService.update(id, updateData)
  }
}
