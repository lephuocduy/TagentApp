import 'package:it_job_mobile/models/response/job_position_response.dart';

import '../../models/response/job_positions_response.dart';

abstract class JobPositionsInterface {
  Future<JobPositionsResponse> searchJobPositions(String url, String query);
  Future<JobPositionResponse> getJobPositionById(String url, String id);
  Future<JobPositionsResponse> getJobPositions(String url);
}
