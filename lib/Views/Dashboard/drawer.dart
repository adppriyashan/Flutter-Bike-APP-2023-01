import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';
import 'package:pickandgo/Models/Utils/Routes.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:pickandgo/Views/Auth/login.dart';
import 'package:pickandgo/Views/Common/leaderboard.dart';
import 'package:pickandgo/Views/Reservations/history.dart';

class DashboardMenu extends StatefulWidget {
  int selection = 1;

  DashboardMenu({Key? key, required selection}) : super(key: key);

  @override
  _DashboardMenuState createState() =>
      _DashboardMenuState(selection: selection);
}

class _DashboardMenuState extends State<DashboardMenu> {
  int selection;

  _DashboardMenuState({required this.selection});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displaySize.width*0.6,
      decoration: BoxDecoration(color: color6),
      child: ListView(
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
                                color: color3, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            CustomUtils.getUser().email,
                            style: GoogleFonts.nunitoSans(
                                color: color3,
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
            tileColor: (selection == 1) ? color4.withOpacity(0.3) : color6,
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
          ListTile(
            tileColor: (selection == 2) ? color4.withOpacity(0.3) : color6,
            leading: Icon(
              Icons.history,
              color: color3.withOpacity(0.8),
            ),
            title: Text(
              'History',
              style: GoogleFonts.nunitoSans(
                  color: color3, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color3,
              size: 15.0,
            ),
            onTap: (){
              Routes(context: context).navigate(ReservationHistory());
            },
          ),
          ListTile(
            tileColor: (selection == 2) ? color4.withOpacity(0.3) : color6,
            leading: Icon(
              Icons.military_tech_outlined,
              color: color3.withOpacity(0.8),
            ),
            title: Text(
              'Leaderboard',
              style: GoogleFonts.nunitoSans(
                  color: color3, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color3,
              size: 15.0,
            ),
            onTap: (){
              Routes(context: context).navigate(LeaderBoard());
            },
          ),
          ListTile(
            tileColor: color6,
            leading: Icon(
              Icons.logout,
              color: color3.withOpacity(0.8),
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.nunitoSans(
                  color: color3, fontWeight: FontWeight.w400),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: color3,
              size: 15.0,
            ),
            onTap: (){
              Routes(context: context).navigateReplace(const Login());
            },
          ),
        ],
      ),
    );
  }
}
