import 'package:dio/dio.dart';
import 'package:meeting_planner/src/model/classes/booking.dart';
import 'package:meeting_planner/src/model/inputs/meeting_input.dart';

import 'package:retrofit/retrofit.dart';

part 'booking_service.g.dart';

@RestApi()
abstract class BookingService {
  factory BookingService(Dio dio) = _BookingService;

  @POST("/admin/booking")
  Future<Booking> createBooking(@Body() MeetingInput input);

  @GET("/admin/booking/{id}")
  Future<Booking> getBooking(@Path("id") int id);

  @GET("/admin/booking")
  Future<List<Booking>> getAllBookings(
      @Query("index") int index, @Query("size") int size);

  @GET("/admin/booking/count")
  Future<int> getBookingsCount();

  @DELETE("/admin/booking/{id}")
  Future deleteBooking(@Path("id") int id);

  @GET("/admin/booking/date-range")
  Future<List<Booking>> getBookingsByRange(
      @Query("startDate") int startDate, @Query("endDate") int endDate);
}
