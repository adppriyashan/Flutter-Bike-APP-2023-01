import 'package:flutter/material.dart';

class CustomCustomBackButton extends StatefulWidget {
  var onclickFunction;

  CustomCustomBackButton({Key? key, required this.onclickFunction})
      : super(key: key);

  @override
  State<CustomCustomBackButton> createState() => _CustomCustomBackButtonState(
        onclickFunction: onclickFunction,
      );
}

class _CustomCustomBackButtonState extends State<CustomCustomBackButton> {
  var onclickFunction;

  _CustomCustomBackButtonState({required this.onclickFunction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        onPressed: onclickFunction,
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }
}
