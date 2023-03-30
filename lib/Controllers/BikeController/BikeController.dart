import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pickandgo/Controllers/Common/HttpController.dart';
import 'package:pickandgo/Models/Utils/APIRoutes.dart';
import 'package:pickandgo/Models/Utils/JsonResponse.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';

class BikeController {
  final HttpController _httpController = HttpController();

  Future<dynamic> getAvailableBikes(context) async {
    dynamic _listResp = [];
    await _httpController.doGet(APIRoutes.getRoute('GET_AVAILABLE_BIKES'), {}, {
      'user': CustomUtils.getUser().id.toString()
    }).then((Response response) async {
      _listResp = JsonResponse.fromJson(response.data).data;
    });

    return _listResp;
  }

  Future<dynamic> getUserHistory(context) async {
    CustomUtils.showLoader(context);
    List<dynamic> _list = [];
    await _httpController.doGet(APIRoutes.getRoute('HISTORY_RESERVATION'), {}, {
      'user': CustomUtils.getUser().id.toString()
    }).then((Response response) async {
      print('XXXXXXXXXXX');
      print(response.data);
      CustomUtils.hideLoader(context);
      JsonResponse.fromJson(response.data)
          .data
          .forEach((element) => _list.add(element));
    });

    return _list;
  }

  Future<List<dynamic>> getAvailableBikesByOrder(context, data) async {
    CustomUtils.showLoader(context);
    List<dynamic> _list = [];
    await _httpController
        .doGet(APIRoutes.getRoute('GET_AVAILABLE_BIKES_BY_ORDER'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);
      print(response.data);
      JsonResponse.fromJson(response.data)
          .data
          .forEach((element) => _list.add(element));
    });

    return _list;
  }
}
