import { Column, Entity, JoinColumn, JoinTable, ManyToMany, ManyToOne, OneToMany, PrimaryColumn } from 'typeorm';
import { Group } from './group';
import { Poll } from './poll';
import { Comments } from './comments';

@Entity({ name: 'users' })
export class User {
  @PrimaryColumn()
  username: string;

  @Column({ unique: true, nullable: false })
  email: string;

  @Column({ nullable: false })
  password: string;

  @Column({ nullable: false })
  role: string;

  @Column({ name: 'token_blacklist', type: 'simple-array', nullable: true })
  tokenBlackList: string[];

  @OneToMany(() => Comments, (comment) => comment.user)
  comments: Comments[];


  @ManyToOne(() => Group, (group) => group.users, {
    nullable: true,
    eager: false,
    cascade: true,
  })
  @JoinColumn({ name: 'group_id' })
  group: Group;

  @ManyToMany(() => Poll, { nullable: true, cascade: true })
  @JoinTable({ name: 'user_voted_polls' })
  votedPolls: Poll[];
}
