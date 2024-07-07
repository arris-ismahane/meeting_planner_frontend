import 'package:dio/dio.dart';
import 'package:meeting_planner/src/model/classes/room.dart';
import 'package:meeting_planner/src/model/inputs/room_input.dart';

import 'package:retrofit/retrofit.dart';

part 'room_service.g.dart';

@RestApi()
abstract class RoomService {
  factory RoomService(Dio dio) = _RoomService;

  @POST("/admin/room")
  Future<Room> createRoom(@Body() RoomInput input);

  @PUT("/admin/room/{id}")
  Future<Room> updateRoom(@Path("id") int id, @Body() RoomInput input);

  @GET("/admin/room/{id}")
  Future<Room> getRoom(@Path("id") int id);

  @GET("/admin/room")
  Future<List<Room>> getAllRooms(
      @Query("index") int index, @Query("size") int size);

  @GET("/admin/room/count")
  Future<int> getRoomsCount();

  @DELETE("/admin/room/{id}")
  Future deleteRoom(@Path("id") int id);
}
