import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_and_pos/add_user.dart';
import 'package:get_and_pos/bloc/user_bloc.dart';
import 'package:get_and_pos/model/user_model.dart';
import 'package:get_and_pos/repository/repository.dart';

void main() {
  runApp(const BlocApp());
}

class BlocApp extends StatefulWidget {
  const BlocApp({super.key});

  @override
  State<BlocApp> createState() => _BlocAppState();
}

class _BlocAppState extends State<BlocApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            RepositoryProvider.of<UserRepository>(context),
          )..add(LoadUserEvent()),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: RepositoryProvider(
            create: (context) => UserRepository(),
            child: const Home(),
          )),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UserBloc(RepositoryProvider.of<UserRepository>(context))
            ..add(LoadUserEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Test API"),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserLoadState) {
              List<User> user = state.user;
              return ListView.builder(
                itemCount: user.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user[index].title,
                            style: const TextStyle(color: Colors.red),
                          ),
                          Text(
                            user[index].body,
                            style: const TextStyle(color: Colors.blue),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final userRepository = UserRepository();
                                  return AlertDialog(
                                    title: const Text('Delete user'),
                                    content: const Text(
                                        'Are you sure you want to delete this user?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          try {
                                            final isDeleted =
                                                await userRepository
                                                    .deleteUser(1);
                                            if (isDeleted) {
                                              context
                                                  .read<UserBloc>()
                                                  .add(DeleteUserEvent(id: 1));
                                            } else {
                                              context.read<UserBloc>().add(
                                                  UserErrorEvent(
                                                          'Failed to delete user')
                                                      as UserEvent);
                                            }
                                          } catch (e) {
                                            context.read<UserBloc>().add(
                                                UserErrorEvent(e.toString())
                                                    as UserEvent);
                                          }
                                        },
                                        child: const Text('Yes'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('No'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.delete),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            if (state is UserErrorState) {
              return const Center(
                child: Text("Error"),
              );
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddUser()));
          },
          child: Text("Add"),
        ),
      ),
    );
  }
}
