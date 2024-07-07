import 'package:dio/dio.dart';
import 'package:meeting_planner/src/model/classes/shared_equipment.dart';
import 'package:meeting_planner/src/model/inputs/shared_equipment_input.dart';

import 'package:retrofit/retrofit.dart';

part 'shared_equipment_service.g.dart';

@RestApi()
abstract class SharedEquipmentService {
  factory SharedEquipmentService(Dio dio) = _SharedEquipmentService;

  @POST("/admin/shared-equipment")
  Future<SharedEquipment> createSharedEquipment(
      @Body() SharedEquipmentInput input);

  @PUT("/admin/shared-equipment/{id}")
  Future<SharedEquipment> updateSharedEquipment(
      @Path("id") int id, @Body() SharedEquipmentInput input);

  @GET("/admin/shared-equipment/{id}")
  Future<SharedEquipment> getSharedEquipment(@Path("id") int id);

  @GET("/admin/shared-equipment")
  Future<List<SharedEquipment>> getAllSharedEquipments(
      @Query("index") int index, @Query("size") int size);

  @GET("/admin/shared-equipment/count")
  Future<int> getSharedEquipmentsCount();

  @DELETE("/admin/shared-equipment/{id}")
  Future deleteSharedEquipment(@Path("id") int id);
}
