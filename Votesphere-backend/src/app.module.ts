import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { GroupModule } from './group/group.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './typeORM/entities/user';
import { Group } from './typeORM/entities/group';
import { Poll } from './typeORM/entities/poll';
import { PollOption } from './typeORM/entities/polloption';
import { PollModule } from './poll/poll.module';
import { Comments } from './typeORM/entities/comments';

@Module({
  imports: [
    AuthModule,
    UsersModule,
    GroupModule,
    PollModule,
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'db',
      port: 5432,
      username: 'postgres',
      password: 'cBeYjAqy@8F}gc1H1545~!',
      database: 'votesphere',
      autoLoadEntities: true,
      entities: [User, Group, PollOption, Poll, Comments],
      synchronize: true,
      logging: true,
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
