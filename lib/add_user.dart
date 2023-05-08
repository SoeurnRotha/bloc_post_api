import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_and_pos/bloc/user_bloc.dart';
import 'package:get_and_pos/repository/repository.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController title = TextEditingController();
  final TextEditingController body = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            input(title, 'title'),
            input(body, 'body'),
            ElevatedButton(
              onPressed: () async {
                final titleText = title.text;
                final bodyText = body.text;

                // Validate user input
                if (titleText.isEmpty || bodyText.isEmpty) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter a title and body'),
                  ));
                  return;
                }

                final userRepository = UserRepository();
                try {
                  // Add new user to the database
                  final newUser =
                      await userRepository.postUser(titleText, bodyText);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('User created successfully'),
                  ));
                  // Navigate to user details screen
                  // Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserDetailsScreen(newUser)));
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error creating user: $e'),
                  ));
                }
              },
              child: Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Widget input(TextEditingController controller, String lable) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(label: Text(lable), border: OutlineInputBorder()),
      ),
    );
  }
}
