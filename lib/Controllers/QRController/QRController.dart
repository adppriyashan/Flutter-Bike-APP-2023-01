import 'package:dio/dio.dart';
import 'package:pickandgo/Controllers/Common/HttpController.dart';
import 'package:pickandgo/Models/DB/User.dart';
import 'package:pickandgo/Models/Utils/APIRoutes.dart';
import 'package:pickandgo/Models/Utils/JsonResponse.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';

class QRController {
  final HttpController _httpController = HttpController();

  Future<void> scanQRCode(context, Map<String, dynamic> data) async {
    CustomUtils.showLoader(context);
    await _httpController
        .doGet(APIRoutes.getRoute('QRSCAN'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
      print(response.data.toString());
      var resp = JsonResponse.fromJson(response.data);
      if (resp.statusCode == 200) {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.SUCCESS_SNACKBAR);
      } else {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.ERROR_SNACKBAR);
      }
    });
  }

  Future<void> reserveByHour(context, Map<String, dynamic> data) async {
    CustomUtils.showLoader(context);
    await _httpController
        .doGet(APIRoutes.getRoute('TEMP_RESERVATION'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
      print(response.data.toString());
      var resp = JsonResponse.fromJson(response.data);
      if (resp.statusCode == 200) {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.SUCCESS_SNACKBAR);
      } else {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.ERROR_SNACKBAR);
      }
    });
  }

  Future<bool> availabilityQRCode(context, Map<String, dynamic> data) async {
    CustomUtils.showLoader(context);
    bool responseCheck=false;
    await _httpController
        .doGet(APIRoutes.getRoute('AVAILABLE_CHECK'), {}, data)
        .then((Response response) async {
          print(response.data);
      CustomUtils.hideLoader(context);
      var resp = JsonResponse.fromJson(response.data);
      if (resp.statusCode == 200) {
        responseCheck= true;
      }
    });
    return responseCheck;
  }
}
