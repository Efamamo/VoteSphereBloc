import { Module } from '@nestjs/common';
import { GroupController } from './group.controller';
import { GroupService } from './group.service';
import { UsersModule } from 'src/users/users.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Group } from 'src/typeORM/entities/group';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  imports: [UsersModule, TypeOrmModule.forFeature([Group]), AuthModule],
  controllers: [GroupController],
  providers: [GroupService],
  exports: [GroupService],
})
export class GroupModule {}
