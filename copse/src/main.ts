import { NestFactory } from '@nestjs/core'
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger'

import { AppModule } from './modules/app/module'
import { PrismaInterceptor } from './interceptors/prisma.interceptor'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.enableCors({
    origin: [process.env.LARAVEL_URL],
  })

  const config = new DocumentBuilder()
    .setTitle('BRPostal - Copse')
    .setDescription('The BRPostal Copse API')
    .setVersion('1.0')
    .build()
  const document = SwaggerModule.createDocument(app, config)
  SwaggerModule.setup('api', app, document)

  app.useGlobalInterceptors(new PrismaInterceptor())

  await app.listen(8008)
}

bootstrap()
