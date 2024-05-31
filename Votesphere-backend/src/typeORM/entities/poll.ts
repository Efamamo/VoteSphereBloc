import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { PollOption } from './polloption';
import { Group } from './group';
import { Comments } from './comments';

@Entity({ name: 'polls' })
export class Poll {
  @PrimaryGeneratedColumn('uuid', { name: 'poll_id' })
  id: string;

  @Column({ nullable: false })
  question: string;

  @Column({ default: true })
  isOpen: boolean;

  @OneToMany(() => PollOption, (pollOption) => pollOption.poll)
  options: PollOption[];

  @OneToMany(() => Comments, (comment) => comment.poll)
  comments: Comments[];
  

  @ManyToOne(() => Group, (group) => group.polls, { nullable: false, eager: false, cascade: true, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'group_id' })
  group: Group;
}
