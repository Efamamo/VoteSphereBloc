import { AuthGuard } from '@nestjs/passport';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('auth')
export class LocalAuthGuard extends AuthGuard('local') {}
