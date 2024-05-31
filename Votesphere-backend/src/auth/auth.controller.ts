import { Body, Controller, Delete, Get, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { SignInUserDto } from './dtos/signInUserDto.dto';
import { LocalAuthGuard } from './guards/localAuth.guard';
import { RefreshJwtGuard } from './guards/refreshJwtToken.guard';
import { Request } from 'express';
import { CreateUserDto } from 'src/users/dtos/createUserDto.dto';
import { SignInResponseDto } from './dtos/signInResponseDto.dto';
import { JwtGuard } from './guards/jwtAuth.guard';
import { RolesGuard } from './guards/role.guard';
import { Roles } from './decorators/roles.decorator';

@ApiTags('auth')
@ApiBearerAuth()
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('signup')
  @ApiOperation({
    summary: 'Sign Up',
    description: 'Create a new user account.',
  })
  @ApiOkResponse({
    description: 'Returns user details and authentication tokens upon successful sign-up',
  })
  @ApiResponse({
    status: 409,
    description: 'Conflict: A user with the same username or email already exists.',
  })
  @ApiResponse({
    status: 400,
    description: 'Bad Request: The password provided is not strong enough.',
  })
  async signUpUser(@Body() createUserDto: CreateUserDto): Promise<SignInResponseDto> {
    return this.authService.signUp(createUserDto);
  }

  @UseGuards(LocalAuthGuard)
  @Post('signin')
  @ApiOperation({
    summary: 'Sign In',
    description: 'Authenticate and sign in a user.',
  })
  @ApiOkResponse({
    description: 'Returns user details and authentication tokens upon successful sign-in',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized: Invalid username or password',
  })
  async signIn(@Body() signInDto: SignInUserDto): Promise<SignInResponseDto> {
    return this.authService.signIn(signInDto.username);
  }

  @UseGuards(JwtGuard,RolesGuard)
  @Roles(["Admin","User"])
  @Patch('changePassword')
  async changePassword(@Req() request: Request, @Body('newPassword') newPassword: string){
    
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;
    return this.authService.changePassword(username,newPassword)
  }

  @UseGuards(JwtGuard,RolesGuard)
  @Roles(["Admin","User"])
  @Delete('deleteAccount')
  async deleteAccount(@Req() request: Request){
    
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;
    
    return this.authService.deleteAccount(username)
  }


  @UseGuards(RefreshJwtGuard)
  @Get('refresh-token')
  @ApiOperation({
    summary: 'Refresh Authentication Token',
    description: "Obtain a new access token by refreshing the user's authentication token.",
  })
  @ApiOkResponse({
    description: 'Returns a new access token upon successful refresh.',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized: Invalid or expired refresh token',
  })

  async refreshToken(@Req() request: Request): Promise<{ access_token: string }> {
    const token = request.headers.authorization.split(' ')[1];
    const username = this.authService.decodeToken(token)?.username;

    return this.authService.refreshToken(username);
  }

  @Patch('signout')
  @ApiOperation({
    summary: 'Sign Out',
    description: "Revoke the user's JWT token.",
  })
  @ApiOkResponse({
    description: 'Success: JWT token revoked successfully',
  })
  @ApiResponse({
    status: 401,
    description: 'Unauthorized: Invalid or expired refresh token',
  })
  async signOut(@Req() request: Request): Promise<string> {
    const token = request.headers.authorization.split(' ')[1];

    return this.authService.revokeToken(token);
  }
}
