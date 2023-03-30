import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickandgo/Controllers/BikeController/BikeController.dart';
import 'package:pickandgo/Controllers/QRController/QRController.dart';
import 'package:pickandgo/Controllers/UserController/UserController.dart';
import 'package:pickandgo/Models/Strings/dashboard.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';
import 'package:pickandgo/Models/Utils/Routes.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:pickandgo/Views/Dashboard/drawer.dart';
import 'package:pickandgo/Views/Reservations/reservation.dart';
import 'package:pickandgo/Views/Reservations/reservation_payment.dart';
import 'package:pickandgo/Views/Widgets/custom_button.dart';
import 'package:pickandgo/Views/Widgets/custom_text_form_field.dart';

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

  final BikeController _bikeController = BikeController();
  final QRController _qrController = QRController();
  final UserController _userController = UserController();

  final Set<Marker> _availableBikes = {};

  Uint8List? markerIcon;
  Timer? timer;

  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();

  LatLng? _myLocation;
  LatLng? _fromLocation;
  LatLng? _toLocation;

  bool continueReservation = false;

  dynamic availableBikes = [];
  dynamic myExistingRide = 0;

  bool isFirstRequestSent = false;

  late StreamSubscription _streamSubscription;

  double _speed = 0.0;

  @override
  void initState() {
    super.initState();
    _getMyLocation();
    timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => initializeAvailableBikes());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color3,
        systemNavigationBarColor: color3,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color6,
        drawer: DashboardMenu(selection: 1),
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
                                _scaffoldKey.currentState!.closeEndDrawer();
                              } else {
                                _scaffoldKey.currentState!.openDrawer();
                              }
                            },
                            child: Icon(
                              Icons.menu,
                              color: color9,
                            ),
                          ),
                          SizedBox(
                              width: displaySize.width * 0.2,
                              child: Image.asset(white_text_logo)),
                          GestureDetector(
                            onTap: () async {
                              initializeAvailableBikes();
                            },
                            child: Icon(
                              Icons.map_outlined,
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
                      GoogleMap(
                        markers: _availableBikes,
                        mapType: myExistingRide != 0 &&
                                myExistingRide['is_paid'] == '1'
                            ? MapType.hybrid
                            : MapType.terrain,
                        compassEnabled: true,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        initialCameraPosition: startLocation,
                        onMapCreated: (GoogleMapController controller) {
                          if (!_controller.isCompleted) {
                            _controller.complete(controller);
                          }
                        },
                      ),
                      (myExistingRide != 0 && myExistingRide['is_paid'] == '1')
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0)),
                                    color: color3.withOpacity(0.5)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                  width: displaySize.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _qrController.lockStatus(context, {
                                            'id':
                                                myExistingRide['id'].toString(),
                                            'lock_status':
                                                (myExistingRide['bike_data']
                                                            ['locked'] ==
                                                        1)
                                                    ? '0'
                                                    : '1'
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: color3, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(500.0),
                                            color: (myExistingRide['bike_data']
                                                        ['locked'] ==
                                                    1)
                                                ? color13
                                                : color12,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              (myExistingRide['bike_data']
                                                          ['locked'] ==
                                                      1)
                                                  ? Icons.lock_open
                                                  : Icons.lock,
                                              color: color6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _userController.emergency(
                                              context, {'type': 'hospital'});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: color3, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(500.0),
                                            color: color12,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.local_hospital,
                                              color: color6,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _userController.emergency(
                                              context, {'type': 'police'});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: color3, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(500.0),
                                            color: color12,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Icon(
                                              Icons.policy,
                                              color: color6,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Container(
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 15.0, horizontal: 20.0),
                      //     decoration: BoxDecoration(color: color3),
                      //     child: Text(
                      //       _availableBikes.length.toString() + bottom_text,
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500, color: color6),
                      //     ),
                      //   ),
                      // )
                    ],
                  )),
              (myExistingRide != 0 && myExistingRide['is_paid'] == '1')
                  ? Expanded(
                      flex: 0,
                      child: Container(
                        width: double.infinity,
                        color: color3,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomButton(
                                      buttonText: dashboard_new_ride,
                                      textColor: color6,
                                      backgroundColor: color3,
                                      isBorder: false,
                                      borderColor: color6,
                                      onclickFunction: () async {
                                        dynamic previousReservation =
                                            myExistingRide;

                                        await getLocationPredictions(2)
                                            .then((value) {
                                          _qrController.finishRide(context, {
                                            'id':
                                                myExistingRide['id'].toString()
                                          }).then((encodedBikeCode) async {
                                            _qrController
                                                .availabilityQRCode(context, {
                                              'bikeId':
                                                  previousReservation['bike'],
                                              'lng': _toLocation!.longitude
                                                  .toString(),
                                              'ltd': _toLocation!.latitude
                                                  .toString(),
                                              'user': CustomUtils.getUser()
                                                  .id
                                                  .toString(),
                                            }).then((value) {
                                              if (value != 2) {
                                                Routes(context: context)
                                                    .navigate(
                                                        ReservationPayment(
                                                  other: value,
                                                  bike: value['bike'],
                                                  from: LatLng(
                                                      double.parse(value['ltd']
                                                          .toString()),
                                                      double.parse(value['lng']
                                                          .toString())),
                                                  to: LatLng(
                                                      double.parse(_toLocation!
                                                          .latitude
                                                          .toString()),
                                                      double.parse(_toLocation!
                                                          .longitude
                                                          .toString())),
                                                  temp: null,
                                                ));
                                              }
                                            });
                                          });
                                        });
                                      }),
                                )),
                            (_speed > 0)
                                ? Expanded(
                                    child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 3),
                                      child: CustomButton(
                                          buttonText: "${_speed.toInt()}KMPH",
                                          textColor: color6,
                                          backgroundColor: color4,
                                          isBorder: false,
                                          borderColor: color6,
                                          onclickFunction: () async {}),
                                    ),
                                  ))
                                : const SizedBox.shrink(),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: CustomButton(
                                      buttonText: dashboard_finish_ride,
                                      textColor: color6,
                                      backgroundColor: color3,
                                      isBorder: false,
                                      borderColor: color6,
                                      onclickFunction: () async {
                                        FocusScope.of(context).unfocus();
                                        _qrController.finishRide(context, {
                                          'id': myExistingRide['id'].toString()
                                        }).then((value) {
                                          initializeAvailableBikes();
                                        });
                                      }),
                                ))
                          ],
                        ),
                      ))
                  : const SizedBox.shrink()
            ],
          ),
        )),
        floatingActionButton: isFirstRequestSent
            ? (myExistingRide == 0 ||
                    (myExistingRide != 0 && myExistingRide['is_paid'] == '2'))
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (myExistingRide == 0) {
                          _makePreReservation();
                        } else {
                          Routes(context: context).navigate(Reservation(
                              ongoing: myExistingRide,
                              isSearch: (myExistingRide == 0),
                              bikes: availableBikes,
                              from: LatLng(
                                  double.parse(myExistingRide['from_ltd']),
                                  double.parse(myExistingRide['from_lng'])),
                              to: LatLng(double.parse(myExistingRide['to_ltd']),
                                  double.parse(myExistingRide['to_lng']))));
                        }
                      },
                      label: Text(
                        myExistingRide == 0
                            ? dashboard_make_an_reservation.toUpperCase()
                            : dashboard_make_an_reservation_qr.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: color6),
                      ),
                      icon: Icon(
                        myExistingRide == 0
                            ? Icons.bike_scooter
                            : Icons.lock_clock,
                        color: color6,
                      ),
                      backgroundColor: color3,
                    ),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink());
  }

  Future<void> _getMyLocation() async {
    CustomUtils.getCurrentPosition().then((value) async {
      _myLocation = LatLng(value.latitude, value.longitude);
      _fromLocation = LatLng(value.latitude, value.longitude);
      _from.text = dashboard_my_location.toUpperCase();

      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 12)));
      initializeAvailableBikes();
    });
  }

  Future<void> getLocationPredictions(type) async {
    if (type == 1) {
      _from.text = '';
      _fromLocation = null;
    } else {
      _to.text = '';
      _toLocation = null;
    }

    await PlacesAutocomplete.show(
        context: context,
        apiKey: CustomUtils.mapsApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "lk",
        types: [],
        onError: (val) {},
        radius: 500000,
        strictbounds: true,
        location:
            Location(lat: _myLocation!.latitude, lng: _myLocation!.longitude),
        components: [
          Component(Component.country, "lk")
        ]).then((Prediction? value) async {
      if (value != null) {
        if (type == 1) {
          _from.text = value.structuredFormatting!.mainText;
          getPlaceData(type, value.placeId);
        } else {
          _to.text = value.structuredFormatting!.mainText;
          getPlaceData(type, value.placeId);
        }
      }
    });
  }

  void _makePreReservation() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Wrap(
            children: [
              Center(
                child: Text(
                  dashboard_make_an_reservation.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.w500),
                ),
              ),
              Divider(
                color: color3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: GestureDetector(
                  onTap: () => getLocationPredictions(1),
                  child: CustomTextFormField(
                    readOnly: true,
                    height: 5.0,
                    backgroundColor: color7,
                    iconColor: color3,
                    isIconAvailable: true,
                    hint: 'Start your tour from',
                    icon: Icons.search,
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: _from,
                    validation: (value) {
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: GestureDetector(
                  onTap: () => getLocationPredictions(2),
                  child: CustomTextFormField(
                    readOnly: true,
                    height: 5.0,
                    backgroundColor: color7,
                    iconColor: color3,
                    isIconAvailable: true,
                    hint: 'Destination',
                    icon: Icons.search,
                    textInputType: TextInputType.text,
                    obscureText: false,
                    controller: _to,
                    validation: (value) {
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Center(
                  child: CustomButton(
                      buttonText: dashboard_show_availabilities.toUpperCase(),
                      textColor: color6,
                      backgroundColor: color3,
                      isBorder: false,
                      borderColor: color6,
                      onclickFunction: () async {
                        if (continueReservation && _fromLocation != null) {
                          FocusScope.of(context).unfocus();
                          await _bikeController
                              .getAvailableBikesByOrder(context, {
                            'lng': _fromLocation!.longitude.toString(),
                            'ltd': _fromLocation!.latitude.toString()
                          }).then((List<dynamic> value) {
                            Navigator.pop(context);
                            Routes(context: context).navigate(Reservation(
                                isSearch: true,
                                bikes: value,
                                from: _fromLocation,
                                to: _toLocation));
                          });
                        } else {
                          Navigator.pop(context);
                          CustomUtils.showSnackBarMessage(
                              context,
                              dashboard_invalid_destinations,
                              CustomUtils.ERROR_SNACKBAR);
                        }
                      }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  initializeAvailableBikes() async {
    markerIcon ??= await getBytesFromAsset(logo, 100);

    // ignore: use_build_context_synchronously
    await _bikeController.getAvailableBikes(context).then((dynamic value) {
      _availableBikes.clear();
      setState(() {
        if (isFirstRequestSent == false) isFirstRequestSent = true;

        myExistingRide = value['ongoing_order'];
        availableBikes = value['bikes'];

        if (initGetSpeed == true &&
            myExistingRide != 0 &&
            myExistingRide['is_paid'] == '1') {
          getSpeed();
          initGetSpeed == false;
        }

        for (var element in value['bikes']) {
          _availableBikes.add(Marker(
            markerId: MarkerId(element['id'].toString()),
            position: LatLng(
              double.parse(element['ltd'].toString()),
              double.parse(element['lng'].toString()),
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon!),
            // onTap: () {
            //   _onMarkerTapped(markerId);
            // },
          ));
        }
      });
    });
  }

  bool initGetSpeed = true;

  Future<void> getPlaceData(type, String? placeId) async {
    await GoogleMapsGeocoding(apiKey: CustomUtils.mapsApiKey)
        .searchByPlaceId(placeId!)
        .then((value) {
      print(value.results[0].geometry.location.lat);
      print(value.results[0].geometry.location.lng);
      if (type == 1) {
        _fromLocation = LatLng(value.results[0].geometry.location.lat,
            value.results[0].geometry.location.lng);
      } else {
        _toLocation = LatLng(value.results[0].geometry.location.lat,
            value.results[0].geometry.location.lng);
      }
    });
    setState(() {
      if (_fromLocation != null && _toLocation != null) {
        print('--------------------------');
        continueReservation = true;
      } else {
        continueReservation = false;
      }
    });
  }

  Future<void> getSpeed() async {
    print("Getting speed");
    _streamSubscription = Geolocator.getPositionStream().listen((position) {
      setState(() {
        _speed = position.speed;
      });
    });
  }
}
