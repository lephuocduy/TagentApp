import 'package:it_job_mobile/models/request/block_request.dart';
import 'package:it_job_mobile/models/response/block_response.dart';
import 'package:it_job_mobile/models/response/blocks_response.dart';

abstract class BlocksInterface {
  Future<BlockResponse> block(String url, BlockRequest request, String accessToken);
  Future<BlocksResponse> getBlockedList(String url, String id);
  Future<String> unBlock(String url, String id, String accessToken);
}