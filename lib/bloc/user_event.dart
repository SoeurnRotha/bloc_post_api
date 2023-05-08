part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class LoadUserEvent extends UserEvent {
  @override
  List<Object> get props => [];
}

class CreateUserEvent extends UserEvent {
  final int id;
  final String title;
  final String body;
  const CreateUserEvent(
      {required this.id, required this.title, required this.body});
  @override
  List<Object?> get props => [id, title, body];
}

class UpdateUserEvent extends UserEvent {
  final int id;
  final String title;
  final String body;
  const UpdateUserEvent(
      {required this.id, required this.title, required this.body});
  @override
  List<Object?> get props => [id, title, body];
}

class DeleteUserEvent extends UserEvent {
  final int id;
  const DeleteUserEvent({required this.id});
  @override
  List<Object?> get props => [id];
}

class UserErrorEvent {
  final String errorMessage;

  UserErrorEvent(this.errorMessage);
}
