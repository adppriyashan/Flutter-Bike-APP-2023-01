import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';

class BiometricsController {
  late final LocalAuthentication _auth;
  late final BuildContext _context;

  BiometricsController(BuildContext context) {
    this._context = context;
    _auth = LocalAuthentication();
  }

  Future<bool> checkSupport() async {
    return (await _auth.canCheckBiometrics && await _auth.isDeviceSupported());
  }

  Future<bool> doAuth() async {
    return await _auth.authenticate(localizedReason: 'Login Authentication');
  }
}
