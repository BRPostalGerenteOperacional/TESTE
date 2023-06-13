import { Injectable } from '@nestjs/common'
import xlsx from 'node-xlsx'

import { PrismaService } from '../prisma/service'
import { CreateFileDTO } from './dto/CreateFile.dto'

@Injectable()
export class RatesService {
  constructor(private readonly prisma: PrismaService) {}

  async create(file: Express.Multer.File, data: CreateFileDTO) {
    const workSheetsFromBuffer = xlsx.parse(`${__dirname}/../../../${file.path}`)[0]
    const rateFile = await this.prisma.rate_files.create({
      data: {
        file: `${file.path}`,
        name: data.file_name,
        state: data.state,
        service_id: Number(data.service_id),
        user_category_id: Number(data.user_category_id),
        admin_id: Number(data.admin_id),
        created_at: new Date(),
        updated_at: new Date(),
        imported_at: new Date(),
      },
    })

    const items = []
    const tasks = workSheetsFromBuffer.data.length
    const itemToConsole = tasks - 1000
    console.log(itemToConsole, workSheetsFromBuffer.data[itemToConsole])

    workSheetsFromBuffer.data.forEach(item => {
      if (item[0] === 'ZipCodeStart') return

      const zipcodeStart = String(item[0]).length === 7 ? `0${item[0]}` : item[0]
      const zipcodeEnd = String(item[1]).length === 7 ? `0${item[1]}` : item[1]

      const itemToPush = {
        zipcode_start: String(zipcodeStart),
        zipcode_end: String(zipcodeEnd),
        polygon_name: item[2],
        weight_start: Number(item[3]),
        weight_end: Number(item[4]),
        absolute_money_cost: item[5],
        price_percent: Number(item[6]),
        price_by_extra_weight: item[7],
        max_volume: item[8],
        time_cost: item[9],
        country: item[10],
        minimum_value_insurance: item[11],
        rate_file_id: rateFile.id,
      }
      items.push(itemToPush)
    })

    console.log(items[1])

    await this.prisma.rates.createMany({
      data: items,
    })

    return { tasks, done: true, rate_file_id: String(rateFile.id) }
  }
}
