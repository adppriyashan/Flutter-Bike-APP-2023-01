import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickandgo/Controllers/QRController/QRController.dart';
import 'package:pickandgo/Models/Strings/reservation.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';
import 'package:pickandgo/Models/Utils/Images.dart';
import 'package:pickandgo/Models/Utils/Routes.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';
import 'package:pickandgo/Models/Validation/FormValidation.dart';
import 'package:pickandgo/Views/Dashboard/dashboard.dart';
import 'package:pickandgo/Views/Widgets/custom_button.dart';
import 'package:pickandgo/Views/Widgets/custom_date_selector.dart';
import 'package:pickandgo/Views/Widgets/custom_text_form_field.dart';

class ReservationPayment extends StatefulWidget {
  dynamic from;
  dynamic to;
  dynamic bike;
  dynamic other;
  dynamic temp;

  ReservationPayment(
      {Key? key,
      required this.bike,
      required this.temp,
      required this.from,
      required this.to,
      required this.other})
      : super(key: key);

  @override
  State<ReservationPayment> createState() =>
      // ignore: no_logic_in_create_state
      _ReservationPaymentState(
          bike: bike, from: from, to: to, other: other, temp: temp);
}

class _ReservationPaymentState extends State<ReservationPayment> {
  LatLng from;
  LatLng to;
  dynamic bike;
  dynamic other, temp;
  _ReservationPaymentState(
      {required this.bike,
      required this.from,
      required this.temp,
      required this.to,
      required this.other});

  final QRController _qrController = QRController();

  final TextEditingController _lastCard = TextEditingController();

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
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        "${double.parse(other['distance'].toString()).toStringAsFixed(2)} KM",
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
                                        other['price'].toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: color4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 60.0),
                          child: Image.asset(paymentTypes),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: CustomTextFormField(
                              readOnly: false,
                              height: 5.0,
                              controller: _lastCard,
                              backgroundColor: color7,
                              iconColor: color3,
                              isIconAvailable: true,
                              hint: reservation_card_no.toUpperCase(),
                              icon: Icons.email_outlined,
                              textInputType: TextInputType.text,
                              validation: (value) =>
                                  FormValidation.notEmptyValidation(value,
                                      'Invalid Email Address / Username'),
                              obscureText: false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: CustomTextFormField(
                              readOnly: false,
                              height: 5.0,
                              controller: TextEditingController(),
                              backgroundColor: color7,
                              iconColor: color3,
                              isIconAvailable: true,
                              hint: reservation_card_holder_name.toUpperCase(),
                              icon: Icons.email_outlined,
                              textInputType: TextInputType.text,
                              validation: (value) =>
                                  FormValidation.notEmptyValidation(value,
                                      'Invalid Email Address / Username'),
                              obscureText: false),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomDateSelectorWithImage(
                                    height: 5.0,
                                    backgroundColor: color7,
                                    isIconAvailable: true,
                                    hint: reservation_card_expire_date_month
                                        .toUpperCase(),
                                    icon_img: Icons.calendar_month,
                                    onConfirm: () {},
                                    type: CustomDateSelectorWithImage
                                        .DATE_SELECTOR,
                                  ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: CustomTextFormField(
                                      readOnly: false,
                                      height: 5.0,
                                      controller: TextEditingController(),
                                      backgroundColor: color7,
                                      iconColor: color3,
                                      isIconAvailable: true,
                                      hint: reservation_card_cvv.toUpperCase(),
                                      icon: Icons.email_outlined,
                                      textInputType: TextInputType.text,
                                      validation: (value) =>
                                          FormValidation.notEmptyValidation(
                                              value,
                                              'Invalid Email Address / Username'),
                                      obscureText: false),
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45.0, vertical: 5.0),
                          child: CustomButton(
                              buttonText: reservation_card_pay,
                              textColor: color6,
                              backgroundColor: color3,
                              isBorder: false,
                              borderColor: color6,
                              onclickFunction: () async {
                                FocusScope.of(context).unfocus();
                                _qrController.scanQRCode(context, {
                                  'temp': temp!=null ? temp['id'] : '',
                                  'code': base64Encode(
                                      utf8.encode(bike.toString())),
                                  'user': CustomUtils.getUser().id.toString(),
                                  'from_lng': from.longitude.toString(),
                                  'from_ltd': from.latitude.toString(),
                                  'to_lng': to.longitude.toString(),
                                  'to_ltd': to.latitude.toString(),
                                  'last_card': _lastCard.text,
                                }).then((value) {
                                  if (value) {
                                    Routes(context: context)
                                        .navigateReplace(const Dashboard());
                                  }
                                });
                              }),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        )));
  }
}
