import { IsEmail, IsIn, IsNotEmpty, Length, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({
    description: 'Email of the user',
    example: 'beka@example.com',
  })
  @IsEmail({}, { message: 'Invalid email format' })
  @IsNotEmpty({ message: 'Email cannot be empty' })
  email: string;

  @ApiProperty({
    description: 'Username of the user',
    example: 'beka_birhanu',
  })
  @IsNotEmpty({ message: 'Username cannot be empty' })
  @Matches(/^[a-zA-Z0-9_.]+$/, {
    message: 'Username must contain only letters, numbers, periods, and underscores',
  })
  @Length(3, 20, { message: 'Username must be between 3 and 20 characters' })
  username: string;

  @ApiProperty({
    description: 'Password of the user',
    example: 'password123',
  })
  @IsNotEmpty({ message: 'Password cannot be empty' })
  password: string;

  comments:  string[];

  @IsNotEmpty({ message: 'role cannot be empty' })
  @IsIn(['Admin', 'User'], { message: 'Role must be either "Admin" or "User"' })
  role: string;
}
