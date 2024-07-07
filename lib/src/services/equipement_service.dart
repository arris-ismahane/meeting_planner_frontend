import 'package:dio/dio.dart';
import 'package:meeting_planner/src/model/classes/equipement.dart';
import 'package:meeting_planner/src/model/inputs/equipement_input.dart';

import 'package:retrofit/retrofit.dart';

part 'equipement_service.g.dart';

@RestApi()
abstract class EquipementService {
  factory EquipementService(Dio dio) = _EquipementService;

  @POST("/admin/equipement")
  Future<Equipement> createEquipement(@Body() EquipementInput input);

  @PUT("/admin/equipement/{id}")
  Future<Equipement> updateEquipement(
      @Path("id") int id, @Body() EquipementInput input);

  @GET("/admin/equipement/{id}")
  Future<Equipement> getEquipement(@Path("id") int id);

  @GET("/admin/equipement")
  Future<List<Equipement>> getAllEquipements(
      @Query("index") int index, @Query("size") int size);

  @GET("/admin/equipement/count")
  Future<int> getEquipementsCount();

  @DELETE("/admin/equipement/{id}")
  Future deleteEquipement(@Path("id") int id);

  @GET("/admin/equipement/date-range")
  Future<List<Equipement>> getEquipementsByRange(
      @Query("startDate") int startDate, @Query("endDate") int endDate);
}
