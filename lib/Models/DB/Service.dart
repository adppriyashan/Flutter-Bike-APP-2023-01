import 'package:pickandgo/Models/Utils/JsonResponse.dart';

class Service {
  var id,
      user_id,
      name,
      icon,
      weekend_availibility,
      date_time_availibility,
      selected_time_shift,
      add_time_restriction_note,
      no_of_visit_availability,
      no_of_visit_count,
      message,
      paymentSettings,
      image,
      status;

  Service(
      this.id,
      this.user_id,
      this.name,
      this.icon,
      this.weekend_availibility,
      this.date_time_availibility,
      this.selected_time_shift,
      this.add_time_restriction_note,
      this.no_of_visit_availability,
      this.no_of_visit_count,
      this.message,
      this.paymentSettings,
      this.image,
      this.status);

  Service.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user_id = json['user_id'],
        name = json['name'],
        weekend_availibility = json['weekend_availibility'],
        date_time_availibility = json['date_time_availibility'],
        selected_time_shift = json['selected_time_shift'],
        add_time_restriction_note = json['add_time_restriction_note'],
        no_of_visit_availability = json['no_of_visit_availability'],
        no_of_visit_count = json['no_of_visit_count'],
        message = json['message'],
        paymentSettings = json['paymentSettings'],
        image = json['image'],
        status = json['status'];
}
