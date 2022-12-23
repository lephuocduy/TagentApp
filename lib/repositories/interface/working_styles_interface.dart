import 'package:it_job_mobile/models/response/working_styles_response.dart';

abstract class WorkingStylesInterface {
  Future<WorkingStylesResponse> getWorkingStyles(String url);
}
