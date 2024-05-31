import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Poll } from './poll';

@Entity({ name: 'options' })
export class PollOption {
  @PrimaryGeneratedColumn('uuid', { name: 'option_id' })
  id: string;

  @Column({ name: 'option_text', nullable: false })
  optionText: string;

  @Column({ name: 'number_of_votes', default: 0 })
  numberOfVotes: number;

  @ManyToOne(() => Poll, (poll) => poll.options, {
    nullable: false,
    eager: false,
    cascade: true,
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'poll_id' })
  poll: Poll;
}
