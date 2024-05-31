extension ExtString on String{
  bool get isValidEmail {
    final emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(this);
  }
  bool get isValidUsername {
    final usernameRegExp = RegExp(
        r'^[a-zA-Z0-9_-]{3,16}$');
    return usernameRegExp.hasMatch(this);
  }
  bool get isValidPassword {
    final passRegExp = RegExp(
        r'^.{8,}$');
    return passRegExp.hasMatch(this);
  }
  bool get isValidConfirmPass {
    final confPassRegExp = RegExp(
        r'^.{8,}$');
    return confPassRegExp.hasMatch(this);
  }
}