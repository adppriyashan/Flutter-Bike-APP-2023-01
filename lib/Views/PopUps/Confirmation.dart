import 'package:flutter/material.dart';
import 'package:pickandgo/Models/Strings/alerts.dart';
import 'package:pickandgo/Models/Strings/common.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Views/Widgets/custom_button.dart';

class Confirmation extends StatefulWidget {
  dynamic title;
  dynamic message;

  Confirmation({required this.title, required this.message});

  @override
  State<StatefulWidget> createState() =>
      ConfirmationState(title: this.title, message: this.message);
}

class ConfirmationState extends State<Confirmation>
    with SingleTickerProviderStateMixin {
  String title;
  String message;

  ConfirmationState({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: color6, borderRadius: BorderRadius.circular(20.0)),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: displaySize.width * 0.8,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Raleway-SemiBold'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        message,
                        style: const TextStyle(
                            fontSize: 15.0, fontFamily: 'Raleway-Regular'),
                      ),
                    ),
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
                                    Navigator.pop(context, true);
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
                                      Navigator.pop(context, false);
                                    }),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
