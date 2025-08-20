import { NestFactory, Reflector } from '@nestjs/core';
import { AppModule } from './app.module';
import { ClassSerializerInterceptor } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as basicAuth from 'express-basic-auth';

void (async () => {
  const app = await NestFactory.create(AppModule);

  app.enableCors();

  app.useGlobalInterceptors(new ClassSerializerInterceptor(app.get(Reflector)));

  app.use(
    ['/swagger'],
    basicAuth({
      users: { [process.env.SWAGGER_USER as string]: process.env.SWAGGER_PASS as string },
      challenge: true,
    }),
  );

  const config = new DocumentBuilder().setTitle('PL PRICE API').setVersion('1.0').build();
  const documentFactory = () => SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('swagger', app, documentFactory);

  await app.listen(process.env.API_PORT ?? 3300);
})();
