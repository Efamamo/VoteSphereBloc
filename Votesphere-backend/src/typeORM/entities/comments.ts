import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Poll } from './poll';
import { User } from './user';

@Entity({ name: 'comments' })
export class Comments {
  @PrimaryGeneratedColumn('uuid', { name: 'comment_id' })
  id: string;

  @Column({ name: 'comment_text', nullable: false })
  commentText: string;

  @ManyToOne(() => Poll, (poll) => poll.comments, {
    nullable: false,
    eager: false,
    cascade: true,
    onDelete: 'CASCADE',
  })
  

  @JoinColumn({ name: 'poll_id' })
  poll: Poll;

  @ManyToOne(() => User, (user) => user.comments, {
    nullable: false,
    eager: false,
    cascade: true,
    onDelete: 'CASCADE',
  })
  
  @JoinColumn({ name: 'user_id' })
  user: User;


}
