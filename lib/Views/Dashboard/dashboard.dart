import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickandgo/Controllers/BikeController/BikeController.dart';
import 'package:pickandgo/Models/Strings/dashboard.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';
import 'package:pickandgo/Models/Utils/Routes.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:pickandgo/Views/Reservations/reservation.dart';
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

  final Set<Marker> _availableBikes = {};

  Uint8List? markerIcon;
  Timer? timer;

  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();

  LatLng? _myLocation;
  LatLng? _fromLocation;
  LatLng? _toLocation;

  bool continueReservation = false;

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
                      ),
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
                  ))
            ],
          ),
        )),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            onPressed: () => _makePreReservation(),
            label: Text(
              dashboard_make_an_reservation.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w500, color: color6),
            ),
            icon: Icon(
              Icons.bike_scooter,
              color: color6,
            ),
            backgroundColor: color3,
          ),
        ));
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

  getLocationPredictions(type) async {
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
                    icon: Icons.start,
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
                    icon: Icons.start,
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
                            Routes(context: context).navigate(Reservation(
                              bikes: value,
                              from: _fromLocation,
                            ));
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
    _availableBikes.clear();
    markerIcon ??= await getBytesFromAsset(logo, 100);

    // ignore: use_build_context_synchronously
    await _bikeController
        .getAvailableBikes(context)
        .then((List<dynamic> value) {
      for (var element in value) {
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
      setState(() {});
    });
  }

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
}
