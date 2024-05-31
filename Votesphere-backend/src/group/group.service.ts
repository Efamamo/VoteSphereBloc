import { BadRequestException, ConflictException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Group } from './../typeORM/entities/group';
import { CreateGroupDto } from './dtos/createGroupDto.dto';
import { UsersService } from 'src/users/users.service';
import { GetGroupResponseDto } from './dtos/getGroupResponseDto.dto';
import { STATUS_CODES } from 'http';

@Injectable()
export class GroupService {
  constructor(
    @InjectRepository(Group)
    private readonly groupRepository: Repository<Group>,
    private readonly usersService: UsersService,
  ) {}

  async createGroup(createGroupDto: CreateGroupDto): Promise<GetGroupResponseDto> {
    const loadGroup = true;
    const adminUser = await this.usersService.findOneByUsername(createGroupDto.adminUsername, loadGroup);

    if (!adminUser) {
      throw new NotFoundException(`User with username ${createGroupDto.adminUsername} not found.`);
    }

    const adminHasGroup = adminUser.group !== null;
    if (adminHasGroup) {
      throw new ConflictException('Admin can create only one group.');
    }

    const group = new Group();
    group.groupName = createGroupDto.groupName;
    group.admin = adminUser;

    const newGroup = await this.groupRepository.save(group);

    adminUser.group = newGroup;
    this.usersService.updateUser(adminUser);

    if (newGroup) {
      const groupDto = {
        groupID: group.id,
        groupName: group.groupName,
        adminUsername: group.admin.username,
      };

      return groupDto;
    } else {
      throw new InternalServerErrorException();
    }
  }

  async getMembers(groupId: string): Promise<{ username: string; email: string; isAdmin: boolean }[]> {
    const group = await this.findOneById(groupId);

    if (!group) {
      throw new NotFoundException('Invalid group ID');
    }

    const members = await this.usersService.getUsersByGroupId(groupId);

    const transformedMembers = members.map((user) => ({
      username: user.username,
      email: user.email,
      isAdmin: user.role === 'Admin' ? true : false,
    }));

    return transformedMembers;
  }

  async addMemberToGroup(newMemberUsername: string, adminUsername: string): Promise<string> {
    const loadGroup = true;
    const admin = await this.usersService.findOneByUsername(adminUsername, loadGroup);
    const adminsGroup = admin.group;

    if (!adminsGroup) {
      throw new NotFoundException('Admins must create a group before attempting to add members');
    }

    const newMember = await this.usersService.findOneByUsername(newMemberUsername, loadGroup);

    if (!newMember) {
      throw new NotFoundException('Invalid username');
    }

    if (newMember.role === 'Admin') {
      throw new ConflictException('There can only be one admin per group');
    }

    const userHasGroup = newMember.group !== null;

    if (userHasGroup) {
      throw new ConflictException(`User '${newMember.username}' already belongs to a group.`);
    }

    newMember.group = adminsGroup;

    const saveSuccess = await this.usersService.updateUser(newMember);

    return saveSuccess ? STATUS_CODES.successful : STATUS_CODES.InternalServerError;
  }

  async removeMemberFromGroup(bannedMemberUsername: string, adminUsername: string): Promise<string> {
    const loadGroup = true;
    const admin = await this.usersService.findOneByUsername(adminUsername, loadGroup);
    const adminsGroup = admin.group;

    if (!adminsGroup) {
      throw new NotFoundException('Admins must create a group before attempting to remove members');
    }

    const bannedMember = await this.usersService.findOneByUsername(bannedMemberUsername, loadGroup);

    if (!bannedMember) {
      throw new NotFoundException('Invalid member username');
    }
    if (bannedMember.role === 'Admin') {
      throw new BadRequestException('Admins can not leave their own group');
    }

    if (!bannedMember.group || bannedMember.group.id != adminsGroup.id) {
      throw new BadRequestException(`User '${bannedMember.username}' is not a member of your group`);
    }

    bannedMember.group = null;
    const saveSuccess = await this.usersService.updateUser(bannedMember);

    return saveSuccess ? STATUS_CODES.successful : STATUS_CODES.InternalServerError;
  }

  async findOneByAdminUsername(adminUsername: string): Promise<Group | undefined> {
    return this.groupRepository.findOne({
      where: { admin: { username: adminUsername } },
    });
  }

  async findOneById(groupId: string): Promise<Group | undefined> {
    return this.groupRepository.findOne({
      where: { id: groupId },
    });
  }

  async belongsTo(username: string, groupId: string): Promise<boolean> {
    const loadGroup = true;
    const user = await this.usersService.findOneByUsername(username, loadGroup);

    if (!user) {
      return false;
    }

    const isMember = user.group.id === groupId;

    return isMember;
  }
}
