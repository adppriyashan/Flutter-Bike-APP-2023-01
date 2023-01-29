class Booking {
  var id,
      business_account_id,
      service_id,
      ref,
      duration,
      picking_time,
      visits,
      message,
      status,
      get_booking_service,
      get_booking_has_pets,
      get_booking_has_days;

  Booking(
      this.id,
      this.business_account_id,
      this.service_id,
      this.ref,
      this.duration,
      this.picking_time,
      this.visits,
      this.message,
      this.status,
      this.get_booking_service,
      this.get_booking_has_pets,
      this.get_booking_has_days);

  Booking.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        business_account_id = json['business_account_id'],
        service_id = json['service_id'],
        ref = json['ref'],
        duration = json['duration'],
        picking_time = json['picking_time'],
        visits = json['visits'],
        message = json['message'],
        status = json['status'],
        get_booking_service = json['get_booking_service'],
        get_booking_has_pets = json['get_booking_has_pets'],
        get_booking_has_days = json['get_booking_has_days'];
}
