import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart';
import 'user_data_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.orange[100],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35.0, 150.0, 35.0, 0.0),
            child: Column(
              children: [
                Text(
                  "Note Memory",
                  style: GoogleFonts.greatVibes(
                    color: Colors.deepOrange,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                //const SizedBox(height: 150.0,),

                Container(
                  height: 300,
                  width: 300,
                  child: Lottie.network(
                    "https://assets3.lottiefiles.com/packages/lf20_z4cshyhf.json",
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(100)
                      ),
                    ),
                    child:  Text(
                      "My Note",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,

                      ),
                    ),
                    onPressed: () {
                        Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomeScreen()));
                        },
                  ),
                ),

                const SizedBox(height: 25.0,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)
                      ),
                    ),
                    child:  Text(
                      "Users Account",
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                        Navigator.push(
                        context, MaterialPageRoute(builder: (_) => UserDataScreen()));
                    },
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
