import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Roles } from '../decorators/roles.decorator';
import { UsersService } from 'src/users/users.service';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { Request } from 'express';
import { AuthService } from '../auth.service';

@Injectable()
@ApiBearerAuth()
@ApiTags('auth')
export class RolesGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly userService: UsersService,
    private readonly authService: AuthService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredRoles = this.reflector.get(Roles, context.getHandler());

    if (!requiredRoles) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeaders(request);

    if (!token) {
      return false;
    }

    const decodedToken = this.authService.decodeToken(token);

    if (!decodedToken) {
      return false;
    }

    const username = decodedToken.username;
    const userRole = await this.userService.getUserRole(username);

    if (this.matchRoles(requiredRoles, userRole)) {
      return true;
    } else {
      // nah ... nah.. not you shames
      return false;
    }
  }

  private extractTokenFromHeaders(request: Request): string | null {
    const authorizationHeader = request.headers.authorization;

    if (authorizationHeader && authorizationHeader.split(' ')[0] == 'Bearer') {
      return authorizationHeader.split(' ')[1];
    }
    return null;
  }

  private matchRoles(rolesRequired: string[], role: string): boolean {
    return rolesRequired.includes(role);
  }
}
