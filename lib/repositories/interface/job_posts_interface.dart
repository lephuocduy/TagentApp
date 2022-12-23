import 'package:it_job_mobile/models/request/share_job_post_request.dart';
import 'package:it_job_mobile/models/response/featured_job_posts_response.dart';
import 'package:it_job_mobile/models/response/share_job_post_response.dart';

import '../../models/response/job_post_response.dart';

abstract class JobPostsInterface {
  Future<FeaturedJobPostsResponse> getJobPostsByIdProfile(String url, String id);
  Future<JobPostResponse> getJobPostById(String url, String id);
  Future<ShareJobPostResponse> shareJobPost(String url, ShareJobPostRequest request, String accessToken);
}
