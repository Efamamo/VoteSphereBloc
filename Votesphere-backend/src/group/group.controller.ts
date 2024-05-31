import { Body, Controller, Get, Param, Post, UseGuards, Req, Delete, UnauthorizedException } from '@nestjs/common';
import { ApiTags, ApiResponse, ApiBearerAuth, ApiOperation, ApiOkResponse, ApiCreatedResponse, ApiBody } from '@nestjs/swagger';
import { Roles } from 'src/auth/decorators/roles.decorator';
import { JwtGuard } from 'src/auth/guards/jwtAuth.guard';
import { RolesGuard } from 'src/auth/guards/role.guard';
import { CreateGroupDto } from './dtos/createGroupDto.dto';
import { GroupService } from './group.service';
import { GetGroupResponseDto } from './dtos/getGroupResponseDto.dto';
import { Request } from 'express';
import { AuthService } from 'src/auth/auth.service';

@ApiTags('groups')
@Controller('groups')
export class GroupController {
  constructor(
    private readonly authService: AuthService,
    private readonly groupService: GroupService,
  ) {}

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin'])
  @Post()
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create Group', description: 'Create a new group. Requires Admin role.' })
  @ApiBody({ type: CreateGroupDto, description: 'Group information including admin username and group name.' })
  @ApiCreatedResponse({ description: 'Group created successfully.', type: GetGroupResponseDto })
  @ApiResponse({ status: 401, description: 'Unauthorized: User lacks necessary permissions.' })
  @ApiResponse({ status: 404, description: 'Not Found: The requesting user does not exist.' })
  @ApiResponse({ status: 409, description: 'Conflict: The requesting admin already has a group.' })
  //
  async createGroup(@Req() request: Request, @Body() createGroupDto: CreateGroupDto): Promise<GetGroupResponseDto> {
    const token = request.headers.authorization.split(' ')[1];
    const header_adminUsername = this.authService.decodeToken(token)?.username;

    if (createGroupDto.adminUsername !== header_adminUsername) {
      throw new UnauthorizedException('User lacks necessary permissions');
    }

    return this.groupService.createGroup(createGroupDto);
  }

  @Roles(['Admin', 'User'])
  @Get(':groupId/members')
  @ApiOperation({ summary: 'Get Members', description: 'Get members of a group. Requires Admin or User role.' })
  @ApiOkResponse({
    description: 'Returns the list of members.',
    schema: {
      type: 'array',
      items: { type: 'object', properties: { username: { type: 'string' }, email: { type: 'string' }, isAdmin: { type: 'boolean' } } },
    },
  })
  @ApiResponse({ status: 404, description: 'Not Found: The provided group ID is invalid.' })
  //
  async getMembers(@Param('groupId') groupId: string): Promise<{ username: string; email: string; isAdmin: boolean }[]> {
    return this.groupService.getMembers(groupId);
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin'])
  @Post(':groupId/members')
  @ApiOperation({ summary: 'Add Member to Group', description: 'Add a user to a group. Requires Admin role.' })
  @ApiBearerAuth()
  @ApiBody({ schema: { properties: { username: { type: 'string', description: 'The username of the user.', example: 'beka_birhanu' } } } })
  @ApiResponse({ status: 200, description: 'Successful operation' })
  @ApiResponse({ status: 401, description: 'Unauthorized: Current user is not admin' })
  @ApiResponse({ status: 404, description: 'Not Found: Invalid username or admin must create a group before attempting to add members' })
  //
  async addMemberToGroup(@Body('username') newMemberUsername: string, @Req() request: Request): Promise<string> {
    const token = request.headers.authorization.split(' ')[1];
    const adminUsername = this.authService.decodeToken(token)?.username;

    return this.groupService.addMemberToGroup(newMemberUsername, adminUsername);
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin'])
  @Delete(':groupId/members')
  @ApiOperation({ summary: 'Remove Member from Group', description: 'Remove a user from a group. Requires Admin role.' })
  @ApiBearerAuth()
  @ApiBody({ schema: { properties: { username: { type: 'string', description: 'The username of the user.', example: 'beka_birhanu' } } } })
  @ApiResponse({ status: 200, description: 'Successful operation' })
  @ApiResponse({ status: 401, description: 'Unauthorized: User does not have permission for the requested group' })
  @ApiResponse({ status: 404, description: 'Not Found: Invalid username or admin must create a group before attempting to remove members' })
  //
  async removeMemberFromGroup(@Body('username') bannedMemberUsername: string, @Req() request: Request): Promise<string> {
    const token = request.headers.authorization.split(' ')[1];
    const adminUsername = this.authService.decodeToken(token)?.username;

    return this.groupService.removeMemberFromGroup(bannedMemberUsername, adminUsername);
  }
}
