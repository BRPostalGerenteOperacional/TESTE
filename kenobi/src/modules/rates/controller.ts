import {
  Body,
  Controller,
  HttpCode,
  Post,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common'
import { FileInterceptor } from '@nestjs/platform-express'
import { ApiExcludeController } from '@nestjs/swagger'
import { CreateFileDTO } from './dto/CreateFile.dto'

import { RatesService } from './service'

@ApiExcludeController()
@Controller('/rates')
export class RatesController {
  constructor(private readonly ratesService: RatesService) {}

  @Post('upload')
  @HttpCode(201)
  @UseInterceptors(FileInterceptor('file', { dest: 'storage/app/uploads/' }))
  uploadFile(@UploadedFile() file: Express.Multer.File, @Body() data: CreateFileDTO) {
    return this.ratesService.create(file, data)
  }
}
