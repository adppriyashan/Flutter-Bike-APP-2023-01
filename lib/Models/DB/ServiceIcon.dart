import 'package:pickandgo/Models/Utils/JsonResponse.dart';

class ServiceIcon {
  final int id,status;
  final String name, image;

  ServiceIcon(this.id, this.name, this.image, this.status);

  ServiceIcon.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        status = json['status'];
}