import { Module } from '@nestjs/common';
import { PollController } from './poll.controller';
import { PollService } from './poll.service';
import { GroupModule } from 'src/group/group.module';
import { UsersModule } from 'src/users/users.module';
import { PollOption } from 'src/typeORM/entities/polloption';
import { Poll } from 'src/typeORM/entities/poll';
import { Group } from 'src/typeORM/entities/group';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from 'src/auth/auth.module';
import { User } from 'src/typeORM/entities/user';
import { Comments } from 'src/typeORM/entities/comments';

@Module({
  controllers: [PollController],
  providers: [PollService],
  imports: [GroupModule, UsersModule, AuthModule, TypeOrmModule.forFeature([Group, Poll, PollOption, User,Comments])],
})
export class PollModule {}
