import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickandgo/Controllers/QRController/QRController.dart';
import 'package:pickandgo/Models/Strings/dashboard.dart';
import 'package:pickandgo/Models/Strings/reservation.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Routes.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:pickandgo/Views/Reservations/reservation_payment.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Reservation extends StatefulWidget {
  dynamic from;
  dynamic to;
  dynamic bikes;

  Reservation({Key? key, required this.bikes, required this.from, required this.to})
      : super(key: key);

  @override
  State<Reservation> createState() =>
      _ReservationState(bikes: bikes, from: from, to: to);
}

class _ReservationState extends State<Reservation> {
  LatLng from;
  LatLng to;
  dynamic bikes;
  _ReservationState({required this.bikes, required this.from,required this.to});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = GlobalKey();

  Barcode? result;
  QRViewController? controller;

  bool isQr = false;

  final QRController _qrController = QRController();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
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
          child: (isQr)
              ? Container(
                  color: color3,
                  child: Center(
                    child: SizedBox(
                      width: displaySize.width * 0.6,
                      height: displaySize.width * 0.6,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _qrCodeViewInitialized,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                        flex: 0,
                        child: Container(
                          decoration: BoxDecoration(color: color3),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 18.0,
                                bottom: 15.0),
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
                                        fontWeight: FontWeight.w500,
                                        color: color6),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(Icons.pedal_bike)
                                        ],
                                      ),
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
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
                                                        bike['distance']
                                                            .toString()) <
                                                    3)
                                                ? color13
                                                : color12),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Wrap(
                                            direction: Axis.horizontal,
                                            spacing: 10.0,
                                            children: [
                                              GestureDetector(
                                                  onTap: () async {
                                                    if (await CustomUtils
                                                        .confirmationAction(
                                                            context,
                                                            "Confirmation",
                                                            "Are you sure to navigate ?")) {
                                                      navigateTo(from.latitude,
                                                          from.longitude);
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.navigation,
                                                    color: color13,
                                                  )),
                                              GestureDetector(
                                                  onTap: () async {
                                                    if (await CustomUtils
                                                        .confirmationAction(
                                                            context,
                                                            "Confirmation",
                                                            "Are you sure reserve until you got it (For Maximum 1 Hour) ?")) {
                                                      navigateTo(from.latitude,
                                                          from.longitude);
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.satellite,
                                                    color: color1,
                                                  )),
                                            ],
                                          )
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                isQr = !isQr;
              });
            },
            label: Text(
              (isQr)
                  ? reservation_go_back.toUpperCase()
                  : reservation_scan_qr.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w500, color: color6),
            ),
            icon: Icon(
              (isQr) ? Icons.close : Icons.qr_code,
              color: color6,
            ),
            backgroundColor: (isQr) ? color12 : color3,
          ),
        ));
  }

  void _qrCodeViewInitialized(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code!.isNotEmpty) {
        if (scanData.code!.contains('p&g_')) {
          String? scannedCode = scanData.code?.replaceAll('p&g_', '');
          setState(() {
            isQr=false;
            if (scannedCode != null) {
              _qrController.availabilityQRCode(context, {
                'code': base64Encode(utf8.encode(scannedCode))
              }).then((value) {
                if (value) {
                  Routes(context: context).navigate(ReservationPayment(
                      bike: scannedCode, from: from, to: null));
                } else {
                  CustomUtils.showSnackBar(context, 'This ride not available',
                      CustomUtils.ERROR_SNACKBAR);
                }
              });
            }
          });
        }
      } else {
        CustomUtils.showSnackBar(
            context, "Invalid QR Code", CustomUtils.ERROR_SNACKBAR);
      }
    });
    controller.pauseCamera();
    controller.resumeCamera();
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
