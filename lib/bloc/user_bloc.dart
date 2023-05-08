// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_and_pos/model/user_model.dart';
import 'package:get_and_pos/repository/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUserEvent>((event, emit) async {
      emit(UserInitial());
      try {
        final user = await userRepository.getAllUser();
        emit(UserLoadState(user));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });

    on<CreateUserEvent>((event, emit) async {
      try {
        final createUser =
            await userRepository.postUser(event.title, event.body);
        print('User created successfully: $createUser');
        emit(CreateUserState(createUser));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
      return;
    });

    on<UpdateUserEvent>((event, emit) async {
      try {
        final updateUser =
            await userRepository.updateUser(event.id, event.title, event.body);
        emit(UpdateUserState(updateUser));
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
      return;
    });
    on<DeleteUserEvent>((event, emit) async {
      try {
        final isDeleted = await userRepository.deleteUser(event.id);
        if (isDeleted) {
          emit(DeleteUserState(event.id));
        } else {
          emit(UserErrorState('Failed to delete user'));
        }
      } catch (e) {
        emit(UserErrorState(e.toString()));
      }
    });
  }
}
