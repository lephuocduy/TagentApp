import 'package:it_job_mobile/models/response/configuration_response.dart';
import 'package:it_job_mobile/models/response/wallet_response.dart';

abstract class WalletInterface {
  Future<WalletResponse> wallet(String url, String id);
  Future<ConfigurationResponse> configuration(String url);
}