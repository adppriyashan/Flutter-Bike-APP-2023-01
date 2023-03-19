import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickandgo/Models/Strings/reservation.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';

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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: color9,
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: Text(
                              reservation_confirmation.toUpperCase(),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: SizedBox(
                            width: displaySize.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_from.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_to.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_est_distance.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_est_price.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_ride_details.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        ':',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: color3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_from.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color13,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_to.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color12,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_est_distance.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_est_price.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        reservation_ride_details.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Image.asset(paymentTypes),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )));
  }
}
