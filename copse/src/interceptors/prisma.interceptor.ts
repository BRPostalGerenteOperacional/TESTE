import {
  BadRequestException,
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common'
import { Observable } from 'rxjs'
import { catchError } from 'rxjs/operators'
import { Prisma } from '@prisma/client'

import { PRISMA_ERRORS } from '../shared/constants/prisma.constants'
import { InvalidFormException } from '../exceptions/invalid.form.exception'

@Injectable()
export class PrismaInterceptor implements NestInterceptor {
  intercept(_: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      catchError(error => {
        if (error instanceof Prisma.PrismaClientKnownRequestError) {
          console.log(error)

          if (error.meta.target) {
            const constraint = ''

            const customMessage = PRISMA_ERRORS[error.code].replace(
              '{constraint}',
              constraint
            )

            const errors = {
              [constraint]: customMessage,
            }

            const prismaErrorSplitStr = `invocation:\n\n\n  `

            const errorMessage =
              error.message.split(prismaErrorSplitStr)[1] || error.message

            throw new InvalidFormException(errors, errorMessage)
          }

          throw new InvalidFormException({}, error.message)
        } else if (error instanceof Prisma.PrismaClientValidationError) {
          throw new BadRequestException(error.message)
        } else {
          throw error
        }
      })
    )
  }
}
