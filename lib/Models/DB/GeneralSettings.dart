class GeneralSettings {
  var id,
      user_id,
      same_day_booking,
      weekend_bookings,
      booking_daily_closing_time,
      max_number_of_booking_per_day,
      notice_period_hrs,
      refund,
      gps_status,
      birthday_message,
      booking_message,
      status;

  GeneralSettings(
      this.id,
      this.user_id,
      this.same_day_booking,
      this.weekend_bookings,
      this.booking_daily_closing_time,
      this.max_number_of_booking_per_day,
      this.notice_period_hrs,
      this.refund,
      this.gps_status,
      this.birthday_message,
      this.booking_message,
      this.status);

  GeneralSettings.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user_id = json['user_id'],
        same_day_booking = json['same_day_booking'],
        weekend_bookings = json['weekend_bookings'],
        booking_daily_closing_time = json['booking_daily_closing_time'],
        max_number_of_booking_per_day = json['max_number_of_booking_per_day'],
        notice_period_hrs = json['notice_period_hrs'],
        refund = json['refund'],
        gps_status = json['gps_status'],
        birthday_message = json['birthday_message'],
        booking_message = json['booking_message'],
        status = json['status'];
}
