import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';

class ReservationPayment extends StatefulWidget {
  dynamic from;
  dynamic to;
  dynamic bike;

  ReservationPayment(
      {Key? key, required this.bike, required this.from, required this.to})
      : super(key: key);

  @override
  State<ReservationPayment> createState() =>
      // ignore: no_logic_in_create_state
      _ReservationPaymentState(bike: bike, from: from, to: to);
}

class _ReservationPaymentState extends State<ReservationPayment> {
  LatLng from;
  LatLng to;
  dynamic bike;
  _ReservationPaymentState(
      {required this.bike, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: color6,
        body: SafeArea(
          child: SizedBox(
              height: displaySize.height,
              width: displaySize.width,
              child: Container()),
        ));
  }
}
