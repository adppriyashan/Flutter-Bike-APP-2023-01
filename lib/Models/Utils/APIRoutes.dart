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
      case 'QRSCAN':
        key = '${_baseRoute}reservation/qrscan';
        break;
    }
    return key;
  }
}
