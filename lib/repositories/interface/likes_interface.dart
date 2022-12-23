
import 'package:it_job_mobile/models/response/like_response.dart';
import 'package:it_job_mobile/models/response/matching_response.dart';

import '../../models/request/like_request.dart';

abstract class LikesInterface {
  Future<LikeResponse> like(String url, LikeRequest request, String accessToken);
  Future<MatchingResponse> getLiked(String url, String id);
  Future<MatchingResponse> getJobPostLiked(String url, String id);
  Future<MatchingResponse> getMatching(String url, String id);
  Future<MatchingResponse> checkLiked(String url, String jobPostId, String profileApplicantId);
}