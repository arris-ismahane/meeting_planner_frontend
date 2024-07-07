import 'package:dio/dio.dart';
import 'package:meeting_planner/src/model/classes/meeting_requirement.dart';
import 'package:meeting_planner/src/model/inputs/meeting_requirement_input.dart';

import 'package:retrofit/retrofit.dart';

part 'meeting_requirement_service.g.dart';

@RestApi()
abstract class MeetingRequirementService {
  factory MeetingRequirementService(Dio dio) = _MeetingRequirementService;

  @POST("/admin/meeting-requirement")
  Future<MeetingRequirement> createMeetingRequirement(
      @Body() MeetingRequirementInput input);

  @PUT("/admin/meeting-requirement/{id}")
  Future<MeetingRequirement> updateMeetingRequirement(
      @Path("id") int id, @Body() MeetingRequirementInput input);

  @GET("/admin/meeting-requirement/{id}")
  Future<MeetingRequirement> getMeetingRequirement(@Path("id") int id);

  @GET("/admin/meeting-requirement")
  Future<List<MeetingRequirement>> getAllMeetingRequirements(
      @Query("index") int index, @Query("size") int size);

  @GET("/admin/meeting-requirement/count")
  Future<int> getMeetingRequirementsCount();

  @DELETE("/admin/meeting-requirement/{id}")
  Future deleteMeetingRequirement(@Path("id") int id);
}
