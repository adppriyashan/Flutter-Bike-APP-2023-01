import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';

class Drawer extends StatefulWidget {
  int selection = 1;

  Drawer({Key? key, required selection}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState(selection: selection);
}

class _DrawerState extends State<Drawer> {
  int selection;

  _DrawerState({required this.selection});


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: double.infinity,
          height: displaySize.height * 0.15,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60.0,
                  width: 60.0,
                  child: ClipOval(
                    child: Image.asset(
                      user,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CustomUtils.getUser().name,
                          style: GoogleFonts.nunitoSans(
                              color: color9,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                         CustomUtils.getUser().email,
                          style: GoogleFonts.nunitoSans(
                              color: color9,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        ListTile(
          tileColor: (selection == 1)
              ? color3.withOpacity(0.3)
              : color7,
          leading: Icon(
            Icons.home,
            color: color3.withOpacity(0.8),
          ),
          title: Text(
            'Home',
            style: GoogleFonts.nunitoSans(
                color: color3, fontWeight: FontWeight.w400),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color3,
            size: 15.0,
          ),
        ),
      ],
    );
  }
}
