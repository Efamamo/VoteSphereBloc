import { ApiProperty } from '@nestjs/swagger';
import { PollOptionDto } from './pollOptionDto.dto'; // Assuming PollOptionDto is defined in another file

export class PollResponseDto {
  @ApiProperty({ description: 'Poll ID' })
  id: string;

  @ApiProperty({ description: 'Poll question' })
  question: string;

  @ApiProperty({ description: 'Is the poll open?' })
  isOpen: boolean;

  @ApiProperty({ type: [PollOptionDto], description: 'Array of poll options' })
  options: PollOptionDto[];
}
