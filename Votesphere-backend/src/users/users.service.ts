import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateUserDto } from './dtos/createUserDto.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from 'src/typeORM/entities/user';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async createUser(createUserDto: CreateUserDto): Promise<User> {
    const salt = await bcrypt.genSalt(10);
    createUserDto.password = await bcrypt.hash(createUserDto.password, salt);

    const newUser: User = this.userRepository.create({
      ...createUserDto,
      comments : [],
      tokenBlackList: null,
    });

    return this.userRepository.save(newUser);
  }

  async updateUser(user: User): Promise<User> {
    return this.userRepository.save(user);
  }

  async addBlackListToken(username: string, token: string): Promise<User> {
    const loadGroup = true;
    const user = await this.findOneByUsername(username, loadGroup);

    if (!user) {
      throw new NotFoundException(`User with username '${username}' not found.`);
    }

    if (!user.tokenBlackList) {
      user.tokenBlackList = [];
    }

    user.tokenBlackList.push(token);

    return this.userRepository.save(user);
  }

  async findOneByUsername(username: string, withGroup: boolean): Promise<User | undefined> {
    const queryOptions: any = { where: { username: username } };

    if (withGroup) {
      queryOptions.relations = ['group'];
    }

    return this.userRepository.findOne(queryOptions);
  }

  async getUsersByGroupId(groupId: string): Promise<{ username: string; email: string; role: string }[]> {
    return this.userRepository.find({
      where: { group: { id: groupId } },
      select: ['username', 'email', 'role'],
    });
  }

  async getUserRole(username: string): Promise<string | undefined> {
    const loadGroup = true;
    const user = await this.findOneByUsername(username, !loadGroup);

    return user?.role;
  }

  async getBlacklistToken(username: string): Promise<string[]> {
    const loadGroup = true;
    const user = await this.findOneByUsername(username, loadGroup);

    return user ? user.tokenBlackList : [];
  }

  async isEmailUsed(email: string): Promise<boolean> {
    const user = await this.userRepository.findOne({
      where: [{ email: email }],
    });

    return !!user;
  }

  async hasVotedOn(username: string, pollID: string): Promise<boolean> {
    const userHasVoted = !!(await this.userRepository
      .createQueryBuilder('user')
      .innerJoin('user.votedPolls', 'votedPolls')
      .where('user.username = :username', { username })
      .andWhere('votedPolls.id = :pollID', { pollID })
      .getOne());

    return userHasVoted;
  }
}
