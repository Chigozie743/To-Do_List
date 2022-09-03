import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/DataBase/database.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/Model/user_model.dart';

import 'home_screen.dart';
import 'user_data_screen.dart';

class AddUserScreen extends StatefulWidget {
  final User? user;
  final Function? updateUserList;

  AddUserScreen({this.user, this.updateUserList});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  String _firstName = "";
  String _lastName = "";
  var _age = "";
  String _gender = "select";

  // DateTime _date = DateTime.now();

  String btnText = "Add User";
  String titleText = "Add User";

  TextEditingController _dateController = TextEditingController();

  // final DateFormat _dateFormatter = DateFormat("MMM dd yyyy");
  final List<String> _genders = ["select", "male", "female", "others"];

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      _firstName = widget.user!.firstName!;
      _lastName = widget.user!.lastName!;
      // _date = widget.user!.date!;
      _age = widget.user!.age!;
      _gender = widget.user!.gender!;

      setState(() {
        btnText = "Update User Data";
        titleText = "Update User Data";
      });
    } else {
      setState(() {
        btnText = "Add User";
        titleText = "Add User";
      });
    }

  }

  // @override
  // void dispose() {
  //   _dateController.dispose();
  //   super.dispose();
  // }

  _delete() {
    DataBaseHelper.instance.deleteUser(widget.user!.iD!);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => UserDataScreen(),
      ),
    );

    widget.updateUserList!();
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_firstName, $_lastName, $_age, $_gender');

      User user = User(firstName: _firstName, lastName: _lastName, age: _age, gender: _gender);

      if (widget.user == null) {
        user.status = 0;
        DataBaseHelper.instance.insertUser(user);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserDataScreen(),
          ),
        );
      } else {
        user.iD = widget.user!.iD;
        user.status = widget.user!.status;
        DataBaseHelper.instance.updateUser(user);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserDataScreen(),
          ),
        );
      }

      widget.updateUserList!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserDataScreen(),
                      )),
                  child: Icon(
                    Icons.arrow_back,
                    size: 30.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  titleText,
                  style: GoogleFonts.lobster(
                    color: Colors.deepOrange,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),

                ),
                SizedBox(
                  height: 10.0,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input!.trim().isEmpty
                              ? "Please enter your first name"
                              : null,
                          onSaved: (input) => _firstName = input!,
                          initialValue: _firstName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input!.trim().isEmpty
                              ? "Please enter your last name"
                              : null,
                          onSaved: (input) => _lastName = input!,
                          initialValue: _lastName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            labelText: "Age",
                            labelStyle: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => input!.trim().isEmpty
                              ? "Please enter your age"
                              : null,
                          onSaved: (input) => _age = input!,
                          initialValue: _age,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22.0,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _genders.map((String gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (input) => _gender == null
                              ? "Please select your gender"
                              : null,
                          onChanged: ((value) => setState(() {
                            _gender = value.toString();
                          })),
                          value: _gender,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ElevatedButton(
                          child: Text(
                            btnText,
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.user != null
                          ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ElevatedButton(
                          child:  Text(
                            "Delete User",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _delete,
                        ),
                      )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
