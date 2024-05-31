import { BadRequestException, ConflictException, Injectable, InternalServerErrorException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';
import * as bcrypt from 'bcrypt';
import { CreateUserDto } from 'src/users/dtos/createUserDto.dto';
import * as zxcvbn from 'zxcvbn';
import { ApiTags } from '@nestjs/swagger';
import { SignInResponseDto } from './dtos/signInResponseDto.dto';
import { STATUS_CODES } from 'http';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/typeORM/entities/user';
import { Repository } from 'typeorm';

@ApiTags('auth')
@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async signUp(createUserDto: CreateUserDto): Promise<SignInResponseDto> {
    createUserDto.comments = [];
    const MINIMUM_PASSWORD_SCORE = 3;
    const isEmailUsed = await this.usersService.isEmailUsed(createUserDto.email);
    const loadGroup = false;
    const isUserNameUsed = await this.usersService.findOneByUsername(createUserDto.username, loadGroup);

    if (isUserNameUsed) {
      throw new ConflictException('User with this username already exists');
    }
    if (isEmailUsed) {
      throw new ConflictException('User with this email already exists');
    }

    const passwordScore = zxcvbn(createUserDto.password).score;
    if (passwordScore < MINIMUM_PASSWORD_SCORE) {
      throw new BadRequestException('Password is not strong enough');
    }

    try {
      await this.usersService.createUser(createUserDto);
      return this.signIn(createUserDto.username);
    } catch (error) {
      throw new InternalServerErrorException('Internal server error');
    }
  }

  async signIn(username: string): Promise<SignInResponseDto> {
    const loadGroup = true;
    const user = await this.usersService.findOneByUsername(username, loadGroup);
    const role = user.role;
    const email = user.email;
    let groupID = null;

    if (user.group) {
      groupID = user.group.id;
    }
    const accessPayload = { email: email, username: username };
    const refreshPayload = { username: username, role: role };

    // by default jwtService is configured for one hour
    const accessToken = await this.jwtService.signAsync(accessPayload);
    const refreshToken = await this.jwtService.signAsync(refreshPayload, {
      expiresIn: '30d',
    });

    return { username, role, groupID, accessToken, refreshToken };
  }

  async refreshToken(username: string): Promise<{ access_token: string }> {
    const loadGroup = false;
    const user = await this.usersService.findOneByUsername(username, loadGroup);

    if (!user) {
      throw new BadRequestException('No such username');
    }
    const email = user.email;
    const payload = { email: email, username: username };

    const access_token = await this.jwtService.signAsync(payload);
    return { access_token };
  }

  async revokeToken(token: string): Promise<string> {
    const decodedToken = await this.decodeToken(token);
    const username = decodedToken.username;

    try {
      await this.usersService.addBlackListToken(username, token);
      return STATUS_CODES.success;
    } catch {
      throw InternalServerErrorException;
    }
  }

  async changePassword(username:string, newPassword:string){
    const MINIMUM_PASSWORD_SCORE = 3;
    const user = await this.usersService.findOneByUsername(username, true);
    if (!user) {
      throw new BadRequestException('No such username');
    }
    if (!newPassword){
      throw new BadRequestException('Password cant be empty')
    }

    const passwordScore = zxcvbn(newPassword).score;
    if (passwordScore < MINIMUM_PASSWORD_SCORE) {
      throw new BadRequestException('Password is not strong enough');
    }

    try {
    const salt = await bcrypt.genSalt(10);
    const password = await bcrypt.hash(newPassword, salt);
    user.password = password;

    await this.usersService.updateUser(user);

    return STATUS_CODES.success

    } catch (error) {
      throw new InternalServerErrorException('Internal server error');
    }
  }

  async deleteAccount(username:string){
    const user = this.usersService.findOneByUsername(username,true);
    if (!user){
      throw new BadRequestException('No such username');
    }

    await this.userRepository.delete(username);
    return STATUS_CODES.success;
  }


  async validatePassword(username: string, plainTextPassword: string): Promise<boolean> {
    const loadGroup = false;
    const user = await this.usersService.findOneByUsername(username, loadGroup);

    if (!user) {
      throw new UnauthorizedException('Invalid username');
    }

    const passwordCheck = await bcrypt.compare(plainTextPassword, user.password);

    if (!passwordCheck) {
      throw new UnauthorizedException('Invalid password');
    }

    return true;
  }

  decodeToken(token: string): any {
    try {
      return this.jwtService.verify(token, { secret: process.env.JWT_SECRET });
    } catch (error) {
      return null;
    }
  }
}
