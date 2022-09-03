import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/DataBase/database.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/Model/user_model.dart';
import 'add_user_data.dart';
import 'welcome_screen.dart';

class UserDataScreen extends StatefulWidget {
  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late Future<List<User>> _userList;


  DataBaseHelper _dataBaseHelper = DataBaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateUserList();
  }

  _updateUserList() {
    _userList = DataBaseHelper.instance.getUserList();
    print(_userList);
  }

  Widget _buildUser(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              user.firstName!,
              style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  decoration: user.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough

              ),

            ),
            subtitle: Text(
              '${user.lastName} | ${user.age} | ${user.gender}',
              style: GoogleFonts.openSans(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  decoration: user.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough

              ),

            ),
            trailing: Checkbox(
              onChanged: (value) {
                user.status = value! ? 1 : 0;
                DataBaseHelper.instance.updateUser(user);
                _updateUserList();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => UserDataScreen()));
              },
              activeColor: Theme.of(context).primaryColor,
              value: user.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddUserScreen(
                  updateUserList: _updateUserList(),
                  user: user,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[100],
        floatingActionButton: SpeedDial(
            icon: Icons.add,
            backgroundColor: Theme.of(context).primaryColor,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.person_add, color: Colors.white,),
                label: 'add user',
                backgroundColor: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => AddUserScreen(
                        updateUserList: _updateUserList,
                      ),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.home, color: Colors.white,),
                label: 'Home',
                backgroundColor: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => WelcomeScreen()));
                },
              ),
            ]
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         CupertinoPageRoute(
        //           builder: (_) => AddUserScreen(
        //             updateUserList: _updateUserList,
        //           ),
        //         ));
        //   },
        //   child: Icon(Icons.person_add),
        // ),
        body: FutureBuilder(
            future: _userList,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final int completedUserCount = snapshot.data!
                  .where((User user) => user.status == 1)
                  .toList()
                  .length;

              return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  itemCount: int.parse(snapshot.data!.length.toString()) + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Users BioData",
                              style: GoogleFonts.lobster(
                                color: Colors.deepOrange,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w600,
                              ),

                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$completedUserCount of ${snapshot.data.length}',
                              style: GoogleFonts.openSans(
                                color: Colors.deepOrange,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),

                            ),
                          ],
                        ),
                      );
                    }
                    return _buildUser(snapshot.data![index - 1]);
                  });
            }));
  }
}
