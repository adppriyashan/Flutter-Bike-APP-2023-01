class APIRoutes {
  static const String _baseRoute = 'http://192.168.1.170:8001/api/';

  static String getRoute(String key) {
    switch (key) {
      case 'REGISTER':
        key = "${_baseRoute}auth/register";
        break;
      case 'LOGIN':
        key = '${_baseRoute}auth/login';
        break;
      case 'EMERGENCY':
        key = '${_baseRoute}emergency/inform';
        break;
      case 'QRSCAN':
        key = '${_baseRoute}reservation/qrscan';
        break;
      case 'LEADERBOARD':
        key = '${_baseRoute}user/leaderboard';
        break;
      case 'TEMP_RESERVATION':
        key = '${_baseRoute}reservation/hour';
        break;
      case 'LOCK_BIKE_RESERVATION':
        key = '${_baseRoute}reservation/lock';
        break;
      case 'FINISH_RESERVATION':
        key = '${_baseRoute}reservation/finish';
        break;
      case 'HISTORY_RESERVATION':
        key = '${_baseRoute}reservation/history';
        break;
      case 'AVAILABLE_CHECK':
        key = '${_baseRoute}reservation/availability';
        break;
      case 'GET_AVAILABLE_BIKES':
        key = '${_baseRoute}bikes/get-available';
        break;
      case 'GET_AVAILABLE_BIKES_BY_ORDER':
        key = '${_baseRoute}bikes/get-available-by-order';
        break;
    }
    return key;
  }
}
