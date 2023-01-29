import 'package:flutter/material.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';

class CustomMultiTextFieldWithImage extends StatefulWidget {
  double height = 5.0;
  String hint;
  String icon_img;
  TextInputType textInputType;
  Color backgroundColor;
  bool isIconAvailable;
  var validation;
  bool obscureText;
  TextEditingController controller;
  var readOnly;

  CustomMultiTextFieldWithImage(
      {Key? key,
      required this.height,
      required this.hint,
      required this.icon_img,
      required this.textInputType,
      required this.backgroundColor,
      required this.isIconAvailable,
      required this.validation,
      required this.controller,
      required this.obscureText,
      this.readOnly})
      : super(key: key);

  @override
  State<CustomMultiTextFieldWithImage> createState() =>
      _CustomMultiTextFieldWithImageState(
          height: height,
          hint: hint,
          icon_img: icon_img,
          textInputType: textInputType,
          backgroundColor: backgroundColor,
          controller: controller,
          isIconAvailable: isIconAvailable,
          validation: validation,
          readOnly: (readOnly != null) ? readOnly as bool : false,
          obscureText: obscureText);
}

class _CustomMultiTextFieldWithImageState
    extends State<CustomMultiTextFieldWithImage> {
  double height = 5.0;
  String hint;
  String icon_img;
  TextInputType textInputType;
  Color backgroundColor;
  bool isIconAvailable;
  var validation;
  bool obscureText;
  TextEditingController controller;
  bool readOnly;

  _CustomMultiTextFieldWithImageState(
      {required this.height,
      required this.hint,
      required this.icon_img,
      required this.textInputType,
      required this.backgroundColor,
      required this.isIconAvailable,
      required this.validation,
      required this.controller,
      required this.readOnly,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.symmetric(vertical: height, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (isIconAvailable == true)
              ? Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    icon_img,
                  ),
                )
              : const SizedBox.shrink(),
          Flexible(
              child: TextFormField(
            maxLines: 6,
            minLines: 1,
            controller: controller,
            obscureText: obscureText,
            cursorColor: color3,
            readOnly: readOnly,
            keyboardType: textInputType,
            validator: validation,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: color8),
                label: Text(hint),
                labelStyle:
                    TextStyle(color: color8, fontFamily: 'Raleway-SemiBold'),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15)),
          ))
        ],
      ),
    );
  }
}
