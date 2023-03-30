import 'package:dio/dio.dart';
import 'package:pickandgo/Controllers/Common/HttpController.dart';
import 'package:pickandgo/Models/Utils/APIRoutes.dart';
import 'package:pickandgo/Models/Utils/JsonResponse.dart';
import 'package:pickandgo/Models/Utils/Utils.dart';

class UserController {
  final HttpController _httpController = HttpController();

  Future<dynamic> getLeaderBoard(context) async {
    CustomUtils.showLoader(context);
    List<dynamic> _list = [];
    await _httpController.doGet(APIRoutes.getRoute('LEADERBOARD'), {}, {
      'user': CustomUtils.getUser().id.toString()
    }).then((Response response) async {
      CustomUtils.hideLoader(context);
      JsonResponse.fromJson(response.data)
          .data
          .forEach((element) => _list.add(element));
    });

    return _list;
  }

  Future<void> emergency(context, Map<String, dynamic> data) async {
    data['user'] = CustomUtils.getUser().id.toString();
    CustomUtils.showLoader(context);
    await _httpController
        .doGet(APIRoutes.getRoute('EMERGENCY'), {}, data)
        .then((Response response) async {
      CustomUtils.hideLoader(context);

      CustomUtils.showSnackBar(
          context, "Emergency alert sent", CustomUtils.SUCCESS_SNACKBAR);
    });
  }
}
