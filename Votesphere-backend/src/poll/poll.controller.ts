import { Body, Controller, Delete, Get, Param, Patch, Post, Query, Req, UnauthorizedException, UseGuards } from '@nestjs/common';
import { PollService } from './poll.service';
import { JwtGuard } from 'src/auth/guards/jwtAuth.guard';
import { RolesGuard } from 'src/auth/guards/role.guard';
import { Roles } from 'src/auth/decorators/roles.decorator';
import { AddPollDto } from './dtos/addPollDto.dto';
import { Poll } from 'src/typeORM/entities/poll';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiBody, ApiParam, ApiQuery } from '@nestjs/swagger';
import { AuthService } from 'src/auth/auth.service';
import { Request } from 'express';
import { STATUS_CODES } from 'http';
import { GroupService } from 'src/group/group.service';
import { PollResponseDto } from './dtos/pollResponseDto.dto';
import { AddCommentDto } from './dtos/addComentDto.dto';
import { Comments } from 'src/typeORM/entities/comments';

@ApiTags('polls')
@Controller('polls')
export class PollController {
  constructor(
    private readonly pollService: PollService,
    private readonly authService: AuthService,
    private readonly groupService: GroupService,
  ) {}

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin'])
  @Post()
  @ApiOperation({ summary: 'Add Poll', description: 'Create a new poll' })
  @ApiBearerAuth()
  @ApiBody({ type: AddPollDto })
  @ApiResponse({ status: 201, description: 'Created', type: PollResponseDto })
  @ApiResponse({ status: 401, description: 'Unauthorized, if the user lacks necessary permissions.' })
  @ApiResponse({ status: 404, description: 'Not Found, if the admin does not have a group.' })
  //
  async addPoll(@Req() request: Request, @Body() addPollDto: AddPollDto): Promise<Poll> {
    const token = request.headers.authorization.split(' ')[1];
    const adminUsername = this.authService.decodeToken(token)?.username;

    return this.pollService.addPoll(addPollDto, adminUsername);
  }



  @UseGuards(RolesGuard,JwtGuard)
  @Roles(["Admin","User"])
  @Post('comments')
  async addComment(@Req() request: Request, @Body() commentDto: AddCommentDto) {
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;
    return this.pollService.addComment(commentDto, username);
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin','User'])
  @Delete('/comments/:id')
  async deleteComment(@Req() request: Request, @Param('id') commentId: string): Promise<string> {
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;
    return this.pollService.removeComment(commentId,username)
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin','User'])
  @Patch('/comments/:id')
  async updateComment(@Req() request: Request, @Param('id') commentId: string,@Body('commentText') commentText: string): Promise<string> {
    
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;
    return this.pollService.updateComment(commentId,commentText,username)
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin'])
  @Delete(':pollId')
  @ApiOperation({ summary: 'Delete Poll', description: 'Delete a poll by ID' })
  @ApiBearerAuth()
  @ApiParam({ name: 'pollId', type: 'string' })
  @ApiResponse({ status: 204, description: 'No Content' })
  @ApiResponse({ status: 400, description: 'Bad Request' })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  @ApiResponse({ status: 404, description: 'Not Found' })
  //
  async deletePoll(@Req() request: Request, @Param('pollId') pollId: string): Promise<string> {
    const token = request.headers.authorization.split(' ')[1];
    const adminUsername = this.authService.decodeToken(token)?.username;

    return this.pollService.removePoll(pollId, adminUsername);
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin'])
  @Patch(':pollId/close')
  @ApiOperation({ summary: 'Close Poll', description: 'Close a poll by ID to prevent further voting' })
  @ApiBearerAuth()
  @ApiParam({ name: 'pollId', type: 'string' })
  @ApiResponse({ status: 200, description: 'OK' })
  async closePoll(@Req() request: Request, @Param('pollId') pollId: string): Promise<string> {
    const token = request.headers.authorization.split(' ')[1];
    const adminUsername = this.authService.decodeToken(token)?.username;

    await this.pollService.closePoll(pollId, adminUsername);

    return STATUS_CODES.success;
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin', 'User'])
  @Patch(':pollId/vote')
  @ApiOperation({ summary: 'Vote on Poll', description: 'Vote on a poll by ID with the specified option' })
  @ApiBearerAuth()
  @ApiParam({ name: 'pollId', type: 'string' })
  @ApiResponse({ status: 200, description: 'OK', type: PollResponseDto })
  async vote(@Req() request: Request, @Param('pollId') pollId: string, @Query('optionId') optionId: string): Promise<Poll> {
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;

    return await this.pollService.castVote(pollId, optionId, username);
  }

  @UseGuards(RolesGuard, JwtGuard)
  @Roles(['Admin', 'User'])
  @Get()
  @ApiOperation({ summary: 'Get Polls', description: 'Get polls by specifying a group ID' })
  @ApiBearerAuth()
  @ApiQuery({ name: 'groupId', type: 'string' })
  @ApiResponse({ status: 200, description: 'OK', type: [PollResponseDto] })
  async getPolls(@Req() request: Request, @Query('groupId') groupId: string): Promise<Poll[]> {
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;

    const userBelongsToRequestedGroup = await this.groupService.belongsTo(username, groupId);

    if (!userBelongsToRequestedGroup) {
      throw new UnauthorizedException('The user does not belong to the requested group');
    }

    return await this.pollService.getPollsByGroupId(groupId);
  }
}
