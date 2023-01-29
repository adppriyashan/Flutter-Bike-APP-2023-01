import 'package:flutter/material.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:pickandgo/Models/Utils/Common.dart';

class CustomDropDown extends StatefulWidget {
  int dropdown_value;
  String leading_image;
  // bool is_leading_icon_avilable;
  var leading_icon;
  var leading_icon_color;
  IconData action_icon;
  Color action_icon_color;
  Color text_color;
  Color background_color;
  Color underline_color;
  var function;
  var items;

  CustomDropDown({
    Key? key,
    required this.dropdown_value,
    this.leading_image = '',
    this.leading_icon,
    this.leading_icon_color,
    required this.action_icon,
    required this.action_icon_color,
    required this.text_color,
    required this.background_color,
    required this.underline_color,
    required this.function,
    required this.items,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState(
        dropdown_value: dropdown_value,
        leading_image: leading_image,
        leading_icon: leading_icon,
        leading_icon_color: leading_icon_color,
        action_icon: action_icon,
        action_icon_color: action_icon_color,
        text_color: text_color,
        background_color: background_color,
        underline_color: underline_color,
        function: function,
        items: items,
      );
}

class _CustomDropDownState extends State<CustomDropDown> {
  int dropdown_value;
  String leading_image;
  var leading_icon;
  var leading_icon_color;
  IconData action_icon;
  Color action_icon_color;
  Color text_color;
  Color background_color;
  Color underline_color;
  var function;
  var items;

  _CustomDropDownState({
    required this.dropdown_value,
    this.leading_image = '',
    this.leading_icon,
    this.leading_icon_color,
    required this.action_icon,
    required this.action_icon_color,
    required this.text_color,
    required this.background_color,
    required this.underline_color,
    required this.function,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: displaySize.width,
        decoration: BoxDecoration(
            color: color6, borderRadius: BorderRadius.circular(5.0)),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Row(
          children: [
            (leading_image != '')
                ? Expanded(flex: 0, child: Image.asset(leading_image))
                : const SizedBox.shrink(),
            (leading_icon != null)
                ? Expanded(
                    flex: 0,
                    child: Icon(
                      leading_icon,
                      color: leading_icon_color,
                    ))
                : const SizedBox.shrink(),
            Expanded(
              flex: 0,
              child: DropdownButton<int>(
                  value: dropdown_value,
                  dropdownColor: color6,
                  elevation: 5,
                  icon: Icon(
                    action_icon,
                    color: color3,
                  ),
                  style:
                      TextStyle(color: color8, fontFamily: 'Raleway-SemiBold'),
                  underline: Container(
                    height: 2,
                    color: color6,
                  ),
                  onChanged: function,
                  items: items),
            )
          ],
        ));
  }
}
