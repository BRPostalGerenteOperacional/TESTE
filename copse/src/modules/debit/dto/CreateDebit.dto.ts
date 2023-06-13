import { DebitOption } from '@prisma/client'

export interface CreateDebitDTO {
  quantity: number
  observation?: string
  laravelOrderId: number
  walletId: string
  debitOption?: DebitOption
}
