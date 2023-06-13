import {
  Injectable,
  NotFoundException,
  HttpException,
  BadRequestException,
} from '@nestjs/common'
import { Prisma, WalletCredit, WalletDebit } from '@prisma/client'
import { DebitService } from '../debit/service'

import { PrismaService } from '../prisma/service'
import { WalletService } from '../wallet/service'
import { CreateRefundDTO } from './dto/CreateRefund.dto'

@Injectable()
export class CreditService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly wallet: WalletService,
    private readonly debit: DebitService
  ) {}

  async create(data: Prisma.WalletCreditCreateManyInput): Promise<WalletCredit> {
    const wallet = await this.wallet.findById(data.walletId)

    if (!wallet) throw new NotFoundException('Wallet not found!')

    if (data.paymentOption === 'Estorno') {
      throw new BadRequestException(
        'Estornos não podem ser feitos nesse controller, leia a documentação'
      )
    }

    const hasUnpayed = await this.prisma.walletCredit.findFirst({
      where: { payedAt: null, walletId: data.walletId },
    })

    if (hasUnpayed) {
      throw new HttpException('Existe um crédito a ser pago', 402)
    }

    const credit = await this.prisma.walletCredit.create({
      data,
    })

    if (credit) await this.wallet.addCredit(data, wallet)

    return credit
  }

  async createRefund(data: CreateRefundDTO): Promise<any> {
    const wallet = await this.wallet.findById(data.walletId)
    if (!wallet) throw new NotFoundException('Wallet not found!')

    const debitToRefund = await this.prisma.walletDebit.findUnique({
      where: {
        id: data.refundDebitId,
      },
      select: {
        quantity: true,
        id: true,
        refunds: {
          select: {
            id: true,
            quantity: true,
          },
        },
      },
    })

    if (!debitToRefund) throw new NotFoundException('Debit not found!')

    let debitRefundsSum = 0

    debitToRefund.refunds.map(refund => {
      debitRefundsSum += Number(refund.quantity)
    })

    const debitAmount = Number(debitToRefund.quantity)
    const canRefund = debitAmount - debitRefundsSum

    const refundQuantityCanBeRefunded = data.quantity <= canRefund

    if (!refundQuantityCanBeRefunded) {
      throw new BadRequestException("Can't be refunded")
    }

    const refund = await this.prisma.walletCredit.create({
      data: {
        paymentOption: 'Estorno',
        quantity: data.quantity,
        observation: data.observation,
        payedAt: new Date(),
        refundDebitId: data.refundDebitId,
        walletId: data.walletId,
      },
    })

    if (refund) await this.wallet.addCredit(data, wallet)

    await this.debit.refundDebit(debitToRefund.id, data.quantity)

    return this.prisma.walletDebit.findUnique({
      where: {
        id: debitToRefund.id,
      },
      include: {
        refunds: true,
      },
    })
  }

  async update(id: string, data: Prisma.WalletCreditUpdateInput) {
    const findCredit = await this.prisma.walletCredit.findUnique({
      where: { id },
    })

    if (!findCredit) throw new NotFoundException('Credit not found')

    return await this.prisma.walletCredit.update({
      where: { id },
      data,
    })
  }

  async delete(id: string) {
    const findCredit = await this.prisma.walletCredit.findUnique({
      where: { id },
    })

    if (!findCredit) throw new NotFoundException('Transaction not found')

    await this.prisma.walletCredit.delete({
      where: { id },
    })
  }
}
