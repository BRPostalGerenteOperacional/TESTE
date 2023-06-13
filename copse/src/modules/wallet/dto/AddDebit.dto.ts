import { Decimal, DecimalJsLike } from '@prisma/client/runtime'

export interface AddDebitDTO {
  quantity: string | number | Decimal | DecimalJsLike
  observation?: string
  walletId: string | number | Decimal | DecimalJsLike
}
