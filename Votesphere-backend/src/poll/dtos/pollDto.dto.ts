import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, ArrayMinSize, ArrayMaxSize } from 'class-validator';

export class PollDto {
  @ApiProperty({
    example: 'What is your favorite color?',
    description: 'Poll question',
  })
  @IsNotEmpty({ message: 'Question is required' })
  @IsString({ message: 'Question must be a string' })
  question: string;

  @ApiProperty({
    example: ['Red', 'Blue', 'Green'],
    description: 'Poll options',
  })
  @ArrayMinSize(2, { message: 'At least two options are required' })
  @ArrayMaxSize(5, { message: 'At maximum five options are allowed' })
  options: string[];
}
