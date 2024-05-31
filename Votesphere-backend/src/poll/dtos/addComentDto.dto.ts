import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';



export class AddCommentDto {
  @IsNotEmpty({ message: 'Comment text is requires' })
  
  
  commentText: string;

  @IsNotEmpty({ message: 'pollId is required' })
  @IsString({ message: 'pollId must be a string' })
  pollId: string;
}
