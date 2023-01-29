import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pickandgo/Models/DB/User.dart';
import 'package:pickandgo/Models/Strings/common.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Views/PopUps/Loading.dart';
import 'package:pickandgo/Views/Widgets/custom_button.dart';

class CustomUtils {
  static const int DEFAULT_SNACKBAR = 1;
  static const int SUCCESS_SNACKBAR = 2;
  static const int ERROR_SNACKBAR = 3;

  static late String loggedInToken;
  static late User loggedInUser;

  static Map<int, Color> tabViewColor = {
    50: color1,
    100: color1,
    200: color1,
    300: color1,
    400: color1,
    500: color1,
    600: color1,
    700: color1,
    800: color1,
    900: color1,
  };

  static getToken() {
    return utf8.decode(base64.decode(loggedInToken));
  }

  static getBearerToken() {
    String token = utf8.decode(base64.decode(loggedInToken));
    return 'Bearer $token';
  }

  static setLoggedToken(token) {
    loggedInToken = base64.encode(utf8.encode(token));
    return loggedInToken;
  }

  static User getUser() {
    return loggedInUser;
  }

  static setLoggedUser(jsonData) async {
    loggedInUser = User.fromJson(jsonData);
    return loggedInUser;
  }

  static Future showLoader(context) async {
    await showDialog(
      context: context,
      builder: (_) => Loading(),
    );
  }

  static Future hideLoader(context) async {
    Navigator.pop(context);
  }

  static String getCurrentDate() {
    return DateFormat("yyyy/MM/dd").format(DateTime.now());
  }

  static String formatDate(DateTime date) {
    return DateFormat("yyyy/MM/dd").format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat("hh:mm a").format(date);
  }

  static String formatTimeAPI(DateTime date) {
    return DateFormat("hh:mm:ss").format(date);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static showSnackBar(context, message, int type) {
    Color backgroundColor = color6;
    Color textColor = color8;
    print(type);
    switch (type) {
      case 1:
        backgroundColor = color6;
        textColor = color8;
        break;
      case 2:
        backgroundColor = color3;
        textColor = color6;
        break;
      case 3:
        backgroundColor = color3;
        textColor = color6;
        break;
      default:
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: TextStyle(fontFamily: 'Raleway-SemiBold', color: textColor),
      ),
    ));
  }

  static Future<bool> showConfirmation(context, description, title) async {
    bool returnAction = false;

    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Raleway-SemiBold'),
                ),
                (description != null)
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          description,
                          style: const TextStyle(
                              fontSize: 15.0, fontFamily: 'Raleway-Regular'),
                        ),
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: CustomButton(
                              buttonText: Confirm_text,
                              textColor: color6,
                              backgroundColor: color3,
                              isBorder: false,
                              borderColor: color6,
                              onclickFunction: () async {
                                returnAction = true;
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: CustomButton(
                                buttonText: Decline_text,
                                textColor: color3,
                                backgroundColor: color6,
                                isBorder: true,
                                borderColor: color3,
                                onclickFunction: () async {
                                  returnAction = false;
                                  Navigator.pop(context);
                                }),
                          ))
                    ],
                  ),
                )
              ],
            ),
          );
        });

    return returnAction;
  }

  static showSnackBarList(context, contents, int type) {
    Color backgroundColor = color6;
    Color textColor = color8;

    switch (type) {
      case 1:
        backgroundColor = color6;
        textColor = color8;
        break;
      case 2:
        backgroundColor = color3;
        textColor = color6;
        break;
      case 3:
        backgroundColor = color6;
        textColor = color8;
        break;
      default:
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Wrap(
        children: [
          for (String message in contents)
            Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                message,
                style:
                    TextStyle(fontFamily: 'Raleway-SemiBold', color: textColor),
              ),
            ),
        ],
      ),
    ));
  }

  static showSnackBarMessage(context, contents, int type) {
    Color backgroundColor = color6;
    Color textColor = color8;
    switch (type) {
      case 1:
        backgroundColor = color6;
        textColor = color8;
        break;
      case 2:
        backgroundColor = color3;
        textColor = color6;
        break;
      case ERROR_SNACKBAR:
        backgroundColor = color12;
        textColor = color9;
        break;
      default:
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child: Text(
          contents,
          style: TextStyle(fontFamily: 'Raleway-SemiBold', color: textColor),
        ),
      ),
    ));
  }

  static getShadow() {
    return <BoxShadow>[
      const BoxShadow(
        color: Colors.black12,
        spreadRadius: -2,
        blurRadius: 5,
        offset: Offset(0, 4), // changes position of shadow
      ),
    ];
  }

  static getShadowForRoundedButton() {
    return <BoxShadow>[
      const BoxShadow(
          color: Colors.black12,
          spreadRadius: -2,
          blurRadius: 5,
          offset: Offset(0, 4))
    ];
  }

  static serverConnectionNotFound() {
    return Fluttertoast.showToast(
        msg: "Unable to connect with server...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color4,
        textColor: color6,
        fontSize: 14.0);
  }

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}
