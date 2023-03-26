import 'package:dio/dio.dart';
import 'package:pickandgo/Controllers/Common/HttpController.dart';
import 'package:pickandgo/Models/DB/User.dart';
import 'package:pickandgo/Models/Utils/APIRoutes.dart';
import 'package:pickandgo/Models/Utils/JsonResponse.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';

class QRController {
  final HttpController _httpController = HttpController();

  Future<bool> scanQRCode(context, data) async {
    bool respCheck = false;
    CustomUtils.showLoader(context);
    await _httpController
        .doGet(APIRoutes.getRoute('QRSCAN'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
      var resp = JsonResponse.fromJson(response.data);
      if (resp.statusCode == 200) {
        respCheck = true;
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.SUCCESS_SNACKBAR);
      } else {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.ERROR_SNACKBAR);
      }
    });
    return respCheck;
  }

  Future<bool> reserveByHour(context, data) async {
    bool respCheck = false;
    CustomUtils.showLoader(context);
    await _httpController
        .doGet(APIRoutes.getRoute('TEMP_RESERVATION'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
      var resp = JsonResponse.fromJson(response.data);
      if (resp.statusCode == 200) {
        respCheck = true;
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.SUCCESS_SNACKBAR);
      } else {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.ERROR_SNACKBAR);
      }
    });
    return respCheck;
  }

  Future<dynamic> availabilityQRCode(context, Map<String, dynamic> data) async {
    CustomUtils.showLoader(context);
    dynamic responseOther = 2;
    await _httpController
        .doGet(APIRoutes.getRoute('AVAILABLE_CHECK'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
      var resp = JsonResponse.fromJson(response.data);
      if (resp.statusCode == 200) {
        responseOther = resp.data;
      } else {
        CustomUtils.showSnackBar(
            context, resp.data, CustomUtils.ERROR_SNACKBAR);
      }
    });
    return responseOther;
  }

  Future<void> finishRide(context, data) async {
    CustomUtils.showLoader(context);
    await _httpController
        .doGet(APIRoutes.getRoute('FINISH_RESERVATION'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
    });
  }
}
