abstract class UserAuthEvent {}
class UserSingIn extends UserAuthEvent {
  String userName;
  String password;
  UserSingIn(this.userName, this.password);
}

class UserSingUp extends UserAuthEvent {
  String userName;
  String password;
  UserSingUp(this.userName, this.password);
}

abstract class UserAuthState {}
class UserAuthInit extends UserAuthState {}
class UserAuthFail extends UserAuthState {
  String errorMsg;
  UserAuthFail(this.errorMsg);
}

class UserAuthSuccess extends UserAuthState {
  String userEmail;
  UserAuthSuccess(this.userEmail);
}