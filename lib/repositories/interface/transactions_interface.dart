import 'package:it_job_mobile/models/response/transaction_job_posts_response.dart';
import 'package:it_job_mobile/models/response/transaction_reward_exchanges_response.dart';

abstract class TransactionsInterface {
  Future<TransactionJobPostsResponse> getTransactionJobPosts(String url, String id);
  Future<TransactionRewardExchangesResponse> getTransactionRewardExchanges(String url, String id);
}