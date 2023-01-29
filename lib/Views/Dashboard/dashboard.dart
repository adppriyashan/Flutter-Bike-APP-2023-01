import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pickandgo/Controllers/QRController/QRController.dart';
import 'package:pickandgo/Models/DB/User.dart';
import 'package:pickandgo/Models/Strings/common.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition startLocation = CameraPosition(
    target: LatLng(7.8589214, 79.5849769),
    zoom: 5,
  );
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isMapView = true;

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
    _getMyLocation();
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
                        left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_scaffoldKey.currentState!.hasDrawer &&
                                _scaffoldKey.currentState!.isEndDrawerOpen) {
                              _scaffoldKey.currentState!.openEndDrawer();
                            } else {
                              _scaffoldKey.currentState!.openDrawer();
                            }
                          },
                          child: Icon(
                            Icons.menu,
                            color: color9,
                          ),
                        ),
                        Text(
                          appName,
                          style: TextStyle(fontSize: 18.0, color: color9),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // await AuthController().logout(context);
                          },
                          child: Icon(
                            Icons.logout,
                            color: color9,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    (_isMapView)
                        ? GoogleMap(
                            mapType: MapType.terrain,
                            compassEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                            initialCameraPosition: startLocation,
                            onMapCreated: (GoogleMapController controller) {
                              if (!_controller.isCompleted) {
                                _controller.complete(controller);
                              }
                            },
                          )
                        : QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          )
                  ],
                ))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: color3,
        onPressed: () async {
          PermissionStatus status = await _getCameraPermission();
          if (status.isGranted) {
            _isMapView = !_isMapView;
            setState(() {
              if (_isMapView) {
                controller?.pauseCamera();
                // _getMyLocation();
              } else {
                controller?.resumeCamera();
              }
            });
          }
        },
        label: Text(
          (_isMapView) ? 'Scan QR' : 'Go Back',
          style: TextStyle(color: color9),
        ),
        icon: Icon(
          (_isMapView) ? Icons.qr_code : Icons.arrow_back,
          color: color9,
        ),
      ),
    );
  }

  Future<void> _getMyLocation() async {
    if (_isMapView) {
      CustomUtils.getCurrentPosition().then((value) async {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude, value.longitude), zoom: 12)));
      });
    }
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   if (_isMapView == false) {
  //     this.controller = controller;
  //     controller.scannedDataStream.listen((scanData) {
  //       result = scanData;
  //       if (result != null) {
  //         controller.pauseCamera();
  //         String? macAddress = result!.code;
  //         print(macAddress);
  //         setState(() {
  //           _isMapView = true;
  //           _qrController.scanQRCode(context, {
  //             'code': base64Encode(utf8.encode(macAddress ?? '')),
  //             'user':
  //                 base64Encode(utf8.encode(CustomUtils.getUser().id.toString()))
  //           });
  //         });
  //       }else{
  //         controller.pauseCamera();
  //   controller.resumeCamera();
  //       }
  //     });
  //   }
  // }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null) {
          controller.pauseCamera();
          String? macAddress = result!.code;
          print(macAddress);
          setState(() {
            _isMapView = true;
            _qrController.scanQRCode(context, {
              'code': base64Encode(utf8.encode(macAddress ?? '')),
              'user':
                  base64Encode(utf8.encode(CustomUtils.getUser().id.toString()))
            });
          });
        }
      });
    });

    if (_isMapView == false) {
      controller.pauseCamera();
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<PermissionStatus> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      return result;
    } else {
      return status;
    }
  }
}
