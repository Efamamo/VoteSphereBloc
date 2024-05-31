import { ApiProperty } from '@nestjs/swagger';

export class PollOptionDto {
  @ApiProperty({ description: 'Option ID' })
  id: string;

  @ApiProperty({ description: 'Option text' })
  optionText: string;

  @ApiProperty({ description: 'Number of votes for this option' })
  numberOfVotes: number;
}
