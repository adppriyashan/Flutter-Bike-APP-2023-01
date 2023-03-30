import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView(
                        children: [
                          for (dynamic history in historyRecords)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Card(
                                child: Wrap(
                                  children: [
                                    ListTile(
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
                                          ['Successful Ride', 'Expired'][
                                              int.parse(history['is_paid']
                                                      .toString()) -
                                                  1],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: [color13, color1][
                                                  int.parse(history['is_paid']
                                                          .toString()) -
                                                      1]),
                                        ),
                                      ),
                                      subtitle: Wrap(
                                        children: [
                                          Text(
                                              "Ride On : ${history['ride_at']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                                color: color3,
                                              )),
                                          (history['drop_at'] != null)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0),
                                                  child: Text(
                                                      "Drop Off : ${history['drop_at']}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12.0,
                                                        color: color3,
                                                      )),
                                                )
                                              : const SizedBox.shrink()
                                        ],
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(history['total'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.0,
                                                color: [color13, color1][
                                                    int.parse(history['is_paid']
                                                            .toString()) -
                                                        1],
                                              ))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: displaySize.height * 0.3,
                                      child: GoogleMap(
                                        mapType: MapType.terrain,
                                        compassEnabled: false,
                                        myLocationEnabled: false,
                                        // liteModeEnabled: true,
                                        zoomControlsEnabled: false,
                                        polylines: {
                                          Polyline(
                                              polylineId: PolylineId(
                                                  history['id'].toString()),
                                              color: color3,
                                              width: 5,
                                              points: history['history']
                                                  .map<LatLng>((p) => LatLng(
                                                      double.parse(
                                                          p['ltd'].toString()),
                                                      double.parse(
                                                          p['lng'].toString())))
                                                  .toList())
                                        },
                                        initialCameraPosition: CameraPosition(
                                          target: history['history'].length > 0
                                              ? LatLng(
                                                  double.parse(
                                                      history['history'][0]
                                                              ['ltd']
                                                          .toString()),
                                                  double.parse(
                                                      history['history'][0]
                                                              ['lng']
                                                          .toString()))
                                              : _defaultCamera,
                                          zoom: 11,
                                        ),
                                        onMapCreated:
                                            (GoogleMapController controller) {},
                                      ),
                                    )
                                  ],
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
