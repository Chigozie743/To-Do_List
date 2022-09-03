import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/DataBase/database.dart';
import 'package:todo/Model/note_model.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo/View/Screens/welcome_screen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _noteList;

  final DateFormat _dateFormatter = DateFormat("MMM dd, yyyy");

  DataBaseHelper _dataBaseHelper = DataBaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _updateNoteList();
  }

  _updateNoteList() {
    _noteList = DataBaseHelper.instance.getNoteList();
    print(_noteList);
  }

  Widget _buildNote(Note note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              note.title!,
              style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  decoration: note.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough

              ),

            ),
            subtitle: Text(
                '${_dateFormatter.format(note.date!)} - ${note.priority}',
              style: GoogleFonts.openSans(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                  decoration: note.status == 0
                         ? TextDecoration.none
                        : TextDecoration.lineThrough

              ),

              ),
            trailing: Checkbox(
              onChanged: (value) {
                note.status = value! ? 1 : 0;
                DataBaseHelper.instance.updateNote(note);
                _updateNoteList();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomeScreen()));
              },
              activeColor: Theme.of(context).primaryColor,
              value: note.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => AddNoteScreen(
                  updateNoteList: _updateNoteList(),
                  note: note,
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
                child: const Icon(Icons.description, color: Colors.white,),
                label: 'add note',
                backgroundColor: Colors.orangeAccent,
                onTap: () {
                  Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => AddNoteScreen(
                                  updateNoteList: _updateNoteList,
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
        body: FutureBuilder(
            future: _noteList,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final int completedNoteCount = snapshot.data!
                  .where((Note note) => note.status == 1)
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
                              "My Notes",
                              style: GoogleFonts.lobster(
                                color: Colors.deepOrange,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w700,
                              ),

                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '$completedNoteCount of ${snapshot.data.length}',
                              style: GoogleFonts.openSans(
                                color: Colors.deepOrange,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // const Spacer(),

                          ],
                        ),
                      );
                    }
                    return _buildNote(snapshot.data![index - 1]);

                  });
            })

    );
  }
}
