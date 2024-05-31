import { IsNotEmpty, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateGroupDto {
  @IsNotEmpty({ message: 'Admins username is required' })
  @IsString({ message: 'Username must be a string' })
  @ApiProperty({ example: 'beka_birhanu', description: 'Admin username' })
  adminUsername: string;

  @IsNotEmpty({ message: 'Group name cannot be empty' })
  @IsString({ message: 'Group name must be a string' })
  @ApiProperty({ example: 'My Group', description: 'Name of the group' })
  groupName: string;
}
