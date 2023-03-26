import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickandgo/Controllers/BikeController/BikeController.dart';
import 'package:pickandgo/Models/Strings/reservation.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReservationHistory extends StatefulWidget {
  ReservationHistory({Key? key}) : super(key: key);

  @override
  State<ReservationHistory> createState() => _ReservationState();
}

class _ReservationState extends State<ReservationHistory> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic historyRecords = [];

  final BikeController _bikeController = BikeController();

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
                                history_title,
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
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView(
                        children: [
                          for (dynamic history in historyRecords)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Card(
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [Icon(Icons.pedal_bike)],
                                  ),
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      ['Successful Ride', 'Expired'][int.parse(
                                              history['is_paid'].toString()) -
                                          1],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: [color13, color1][int.parse(
                                                  history['is_paid']
                                                      .toString()) -
                                              1]),
                                    ),
                                  ),
                                  subtitle: Text(history['ride_at'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        color: color3,
                                      )),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(history['total'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0,
                                            color: [color13, color1][int.parse(
                                                    history['is_paid']
                                                        .toString()) -
                                                1],
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ))
              ]))),
    );
  }

  navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=w");
    if (await canLaunchUrlString(uri.toString())) {
      await launchUrlString(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  void getData() {
    _bikeController.getUserHistory(context).then((value) {
      setState(() {
        historyRecords = value;
      });
    });
  }
}
