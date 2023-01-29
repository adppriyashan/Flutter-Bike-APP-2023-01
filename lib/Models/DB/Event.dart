import '../Utils/Utils.dart';

class Event {
  final int id, pre_booking_type, allocated_booking_count, status;
  var name, message, start_date, start_time, end_date, end_time, admin_remark;

  Event(
      this.id,
      this.name,
      this.start_date,
      this.end_date,
      this.start_time,
      this.end_time,
      this.pre_booking_type,
      this.allocated_booking_count,
      this.message,
      this.admin_remark,
      this.status);

  Event.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        start_date = json['start_date'],
        end_date = json['end_date'],
        start_time = json['start_time'],
        end_time = json['end_time'],
        pre_booking_type = json['pre_booking_type'],
        allocated_booking_count = json['allocated_booking_count'],
        message = json['message'],
        admin_remark = json['admin_remark'],
        status = json['status'];
}
