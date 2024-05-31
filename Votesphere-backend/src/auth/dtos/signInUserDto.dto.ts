import { IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SignInUserDto {
  @ApiProperty({
    description: 'Username for signing in',
    example: 'beka_birhanu',
  })
  @IsNotEmpty({ message: 'Username cannot be empty' })
  username: string;

  @ApiProperty({
    description: 'Password for signing in',
    example: 'password123',
  })
  @IsNotEmpty({ message: 'Password cannot be empty' })
  password: string;
}
