import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickandgo/Models/Strings/dashboard.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Reservation extends StatefulWidget {
  dynamic from;
  dynamic bikes;

  Reservation({Key? key, required this.bikes, required this.from}) : super(key: key);

  @override
  State<Reservation> createState() => _ReservationState(bikes: bikes, from: from );
}

class _ReservationState extends State<Reservation> {
  LatLng from;
  dynamic bikes;
  _ReservationState({required this.bikes,required this.from});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        child: Column(
          children: [
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
                            dashboard_show_availabilities.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: color6),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5.0),
                  child: ListView(
                    children: [
                      for (dynamic bike in bikes)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 3.0),
                          child: Card(
                            child: ListTile(
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [Icon(Icons.pedal_bike)],
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  bike['reference'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              subtitle: Text(
                                "${double.parse(bike['distance'].toString()).toStringAsFixed(1)}KM From You",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                    color: (double.parse(
                                                bike['distance'].toString()) <
                                            3)
                                        ? color13
                                        : color12),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        navigateTo(from.latitude, from.longitude);
                                      },
                                      child: Icon(Icons.navigation))
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ))
          ],
        ),
      )),
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
}
