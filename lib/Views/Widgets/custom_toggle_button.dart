import 'package:flutter/material.dart';
import 'package:pickandgo/Models/Utils/Colors.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomToggleButton extends StatefulWidget {
  var onToggle;

  CustomToggleButton({Key? key, required this.onToggle}) : super(key: key);

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState(onToggle);
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  var onToggle;

  _CustomToggleButtonState(this.onToggle);

  List<bool> toggleButtonValues = [true, false];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ToggleSwitch(
          minHeight: 50.0,
          inactiveBgColor: color9,
          inactiveFgColor: color8,
          activeBgColor: [color6],
          activeFgColor: color3,
          activeBorders: [Border.all(color: color9, width: 3.0)],
          initialLabelIndex: 0,
          totalSwitches: 2,
          labels: const ['Yes', 'No'],
          onToggle: onToggle,
        )
      ],
    );
  }
}
