import 'package:flutter/material.dart';
import 'package:riseup_task/services/remote_service.dart';
import 'package:riseup_task/views/add.dart';

import '../model/usersmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static final GlobalKey<_HomePageState> homePageKey =
  GlobalKey<_HomePageState>();

  static void refreshUserList() {
    homePageKey.currentState?.refreshUserList();
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>?> users;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _getUserList();
  }

  void _getUserList() async {
    try {
      List<User>? userList = await RemoteService().getUsers();
      if (userList != null) {
        setState(() {
          isLoaded = true;
          users = Future.value(userList);
        });
      }
    } catch (error) {
      // Handle error
    }
  }

  void refreshUserList() {
    _getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserPage(),
            ),
          ).then((value) {
            if (value != null && value) {
              HomePage.refreshUserList();
            }
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Visibility(
        visible: isLoaded,
        child: FutureBuilder<List<User>?>(
          future: users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<User>? userList = snapshot.data;
              return ListView.builder(
                itemCount: userList?.length ?? 0,
                itemBuilder: (context, index) {
                  User user = userList![index];
                  return Container(
                    height: 200,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  user.id.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF091F44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF091F44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF091F44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.gender.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF091F44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.status.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF091F44),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 50),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF67EB46),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {

                                    },
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: 120,
                                  height: 32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFEB5A46),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Handle Delete button press
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No users found.'),
              );
            }
          },
        ),
      ),
    );
  }
}