import 'package:flutter/material.dart';
import 'package:riseup_task/model/usersmodel.dart';
import 'package:riseup_task/services/remote_service.dart';
import 'package:riseup_task/views/home_page.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        User user = User(
                          id: 0,
                          // Temporary ID (will be generated by the API)
                          name: _nameController.text,
                          email: _emailController.text,
                          gender: genderValues.map[_genderController.text] ??
                              Gender.MALE,
                          status: statusValues.map['Active'] ??
                              Status.ACTIVE, // Set a default status
                        );
                        try {
                          await RemoteService().addUser(user);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User added successfully'),
                            ),
                          );

                          // Refresh the user list after adding a new user
                          HomePage.refreshUserList();

                          Navigator.pop(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text('Failed to add user.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Add User'),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}