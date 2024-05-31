import { BadRequestException, HttpException, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { GroupService } from 'src/group/group.service';
import { InjectRepository } from '@nestjs/typeorm';
import { DeepPartial, Repository } from 'typeorm';
import { Poll } from 'src/typeORM/entities/poll';
import { PollOption } from 'src/typeORM/entities/polloption';
import { AddPollDto } from './dtos/addPollDto.dto';
import { STATUS_CODES } from 'http';
import { UsersService } from 'src/users/users.service';
import { AddCommentDto } from './dtos/addComentDto.dto';
import { Comments } from 'src/typeORM/entities/comments';
import { use } from 'passport';
import { User } from 'src/typeORM/entities/user';

@Injectable()
export class PollService {
  constructor(
    @InjectRepository(Comments)
    private readonly commentRepository: Repository<Comments>,
    @InjectRepository(User)
    private readonly userRepository : Repository<User>,
    @InjectRepository(Poll)
    private readonly pollRepository: Repository<Poll>,
    @InjectRepository(PollOption)
    private readonly pollOptionRepository: Repository<PollOption>,
    private readonly groupService: GroupService,
    private readonly usersService: UsersService,
  ) {}

  async addPoll(addPollDto: AddPollDto, adminUsername): Promise<Poll> {
    const loadGroup = true;
    const loadPollOptions = true;
    const {
      groupID,
      poll: { question, options },
    } = addPollDto;

    const group = await this.groupService.findOneByAdminUsername(adminUsername);
    if (!group) {
      throw new NotFoundException('Admin must have a group to administer. Create a group first.');
    }

    if (group.id !== groupID) {
      throw new UnauthorizedException('User lacks necessary permissions');
    }

    const newPoll = this.pollRepository.create({ question, group });
    const savedPoll = await this.pollRepository.save(newPoll);

    const pollOptions = options.map((optionText: string) =>
      this.pollOptionRepository.create({
        optionText,
        poll: savedPoll,
      }),
    );
    await this.pollOptionRepository.save(pollOptions);
    newPoll.options = pollOptions;

    return this.findOne(newPoll.id, !loadGroup, loadPollOptions);
  }

  async addComment(commentDto: AddCommentDto, username: string) {
    const { pollId, commentText } = commentDto;
    const poll = await this.findOne(pollId,true,true); // Assuming you have a method to find a poll by ID
    const user = await this.usersService.findOneByUsername(username, true);

    if (!poll) {
      throw new NotFoundException('Poll not found');
    }

    if(!user){
      throw new NotFoundException('user not found');
    }

    const newComment = this.commentRepository.create({ commentText ,poll, user});

    const savedComment = await this.commentRepository.save(newComment);
    return savedComment;

  }

  async removeComment(commentId: string, username: string): Promise<string> {

    const loadGroup = true;
    const loadPollOptions = true;
    const user = await this.usersService.findOneByUsername(username, loadGroup);

    if(!commentId){
      throw new BadRequestException("Comment Id is required")
    }
    const commentToRemove = await this.findCommentById(commentId);

    if (!commentToRemove) {
      throw new NotFoundException('Comment not found.');
    }

    if (!user) {
      throw new NotFoundException('Invalid admin username');
    }

    if (user.username !== commentToRemove.user.username) {
      throw new UnauthorizedException('User lacks necessary permissions: The Comment does not belong to the user');
    }


    await this.commentRepository.delete(commentId);
    return STATUS_CODES.success;
  }


  async updateComment(commentId: string,commentText: string, username: string){
    const loadGroup = true;
    const loadPollOptions = true;
    const user = await this.usersService.findOneByUsername(username, loadGroup);

    if(!commentId){
      throw new BadRequestException("Comment Id is required")
    }
    if (!commentText){
      throw new HttpException("Comment text Should Not be Empty",401)
    }
    const commentToUpdate = await this.findCommentById(commentId);

    if (!commentToUpdate) {
      throw new NotFoundException('Comment not found.');
    }

    if (!user) {
      throw new NotFoundException('Invalid admin username');
    }
   

    if (user.username !== commentToUpdate.user.username) {
      throw new UnauthorizedException('User lacks necessary permissions: The Comment does not belong to the user');
    }

    

    commentToUpdate.commentText = commentText;
    await this.commentRepository.save(commentToUpdate);
    
    return STATUS_CODES.success;
  }

  async removePoll(pollId: string, adminUsername: string): Promise<string> {
    const loadGroup = true;
    const loadPollOptions = true;
    const adminUser = await this.usersService.findOneByUsername(adminUsername, loadGroup);
    const pollToRemove = await this.findOne(pollId, loadGroup, loadPollOptions);

    if (!pollToRemove) {
      throw new NotFoundException('Poll not found.');
    }

    if (!adminUser) {
      throw new NotFoundException('Invalid admin username');
    }

    if (adminUser.group.id !== pollToRemove.group.id) {
      throw new UnauthorizedException('User lacks necessary permissions: The poll does not belong to their group');
    }

    let hasBeenVotedOn = false;
    for (const option of pollToRemove.options) {
      if (option.numberOfVotes > 0) {
        hasBeenVotedOn = true;
        break;
      }
    }

    if (hasBeenVotedOn) {
      throw new BadRequestException('If a vote has been cast, the poll cannot be deleted. It can only be closed.');
    }

    await this.pollRepository.delete(pollId);

    return STATUS_CODES.success;
  }

  async closePoll(pollId: string, adminUsername: string): Promise<Poll> {
    const loadGroup = true;
    const loadPollOptions = true;
    const adminUser = await this.usersService.findOneByUsername(adminUsername, loadGroup);
    const pollToClose = await this.findOne(pollId, loadGroup, loadPollOptions);

    if (!pollToClose) {
      throw new NotFoundException('Poll not found.');
    }

    if (adminUser.group.id !== pollToClose.group.id) {
      throw new UnauthorizedException('User lacks necessary permissions: The poll does not belong to their group');
    }

    pollToClose.isOpen = false;

    return this.pollRepository.save(pollToClose);
  }



  async castVote(pollId: string, optionId: string, username: string): Promise<Poll> {
    const loadGroup = true;
    const loadPollOptions = true;
    const pollToVote = await this.findOne(pollId, loadGroup, loadPollOptions);

    if (!pollToVote) {
      throw new NotFoundException('Poll not found.');
    }

    if (!pollToVote.isOpen) {
      throw new BadRequestException('Poll is closed.');
    }

    const user = await this.usersService.findOneByUsername(username, loadGroup);
    if (!user.group || pollToVote.group.id !== user.group.id) {
      throw new BadRequestException("Poll does not belong to the user's group.");
    }

    const hasVotedOn = await this.usersService.hasVotedOn(username, pollId);
    if (hasVotedOn) {
      throw new BadRequestException('User has already voted on this poll.');
    }

    const selectedOption = pollToVote.options.find((option) => option.id == optionId);
    if (!selectedOption) {
      throw new NotFoundException('Poll option not found.');
    }

    selectedOption.numberOfVotes++;
    await this.pollOptionRepository.save(selectedOption);

    user.votedPolls = [...(user.votedPolls || []), pollToVote];
    await this.usersService.updateUser(user);

    return this.findOne(pollId, false, true);
  }

  async findOne(id: string, withGroup: boolean, withOptions: boolean): Promise<Poll> {
    const relations = [];

    if (withGroup) {
      relations.push('group');
    }

    if (withOptions) {
      relations.push('options');
    }

    return this.pollRepository.findOne({ where: { id: id }, relations: relations });
  }

  async findCommentById(id:string){
      const relations = ['user']
      return this.commentRepository.findOne({where: { id: id },relations: relations})
  }

  async getPollsByGroupId(groupId: string): Promise<Poll[]> {
    return this.pollRepository
      .createQueryBuilder('poll')
      .leftJoinAndSelect('poll.options', 'options')
      .leftJoinAndSelect('poll.comments', 'comments')
      .where('poll.group.id = :groupId', { groupId })
      .getMany();
  }
  
}
