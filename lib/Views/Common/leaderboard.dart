import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickandgo/Controllers/BikeController/BikeController.dart';
import 'package:pickandgo/Controllers/UserController/UserController.dart';
import 'package:pickandgo/Models/Strings/reservation.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LeaderBoard extends StatefulWidget {
  LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _ReservationState();
}

class _ReservationState extends State<LeaderBoard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic historyRecords = [];

  final UserController _userController = UserController();

  final LatLng _defaultCamera = const LatLng(6.862484, 79.885498);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: color6,
      body: SafeArea(
          child: SizedBox(
              height: displaySize.height,
              width: displaySize.width,
              child: Column(children: [
                Expanded(
                    flex: 0,
                    child: Container(
                      decoration: BoxDecoration(color: color3),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 18.0, bottom: 15.0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: color9,
                              ),
                            ),
                            Center(
                              child: Text(
                                leaderboard_title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: color6,
                                    fontSize: 16.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView(
                          children:
                              List.generate(historyRecords.length, (index) {
                        dynamic data = historyRecords[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.military_tech,
                                    color: getStatusColor(index),
                                  )
                                ],
                              ),
                              title: Text(
                                "${data['distance']}KM",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: getStatusColor(index)),
                              ),
                              subtitle: Text(
                                data['name'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: color3,
                                    fontSize: 12.0),
                              ),
                              trailing: (index == 0)
                                  ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.workspace_premium)
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        );
                      })),
                    ))
              ]))),
    );
  }

  void getData() {
    _userController.getLeaderBoard(context).then((value) {
      setState(() {
        historyRecords = value;
      });
    });
  }

  Color getStatusColor(int index) {
    List<Color> colors = [color13, color2, color1, color11, color12];
    return (colors[index] != null) ? colors[index] : color4;
  }
}
