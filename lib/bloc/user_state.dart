part of 'user_bloc.dart';

abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class UserLoadState extends UserState {
  UserLoadState(this.user);
  final List<User> user;
  @override
  List<Object?> get props => [user];
}

// ignore: must_be_immutable
class UserErrorState extends UserState {
  UserErrorState(this.error);
  String error;
  @override
  List<Object?> get props => [error];
}

class CreateUserState extends UserState {
  final User user;
  CreateUserState(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateUserState extends UserState {
  final User user;
  UpdateUserState(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUserState extends UserState {
  final int userId;

  DeleteUserState(this.userId);

  @override
  List<Object?> get props => [userId];
}
