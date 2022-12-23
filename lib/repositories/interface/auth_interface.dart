import 'package:it_job_mobile/models/request/sign_in_request.dart';
import 'package:it_job_mobile/models/request/sign_up_request.dart';
import 'package:it_job_mobile/models/response/applicant_response.dart';
import 'package:it_job_mobile/models/response/sign_in_response.dart';

abstract class AuthInterface {
  Future<SignInResponse> signIn(String url, SignInRequest request);
  Future<ApplicantResponse> signUp(String url, SignUpRequest request);
  Future<String> getOTP(String url, String phone);
  Future<String> verifyOTP(String url, String OTP, String phone);
  Future<String> changePassword(String url, String id, String currentPassword, String newPassword, String accessToken);
  Future<String> forgotPassword(String url, String phone,String OTP, String newPassword);
}