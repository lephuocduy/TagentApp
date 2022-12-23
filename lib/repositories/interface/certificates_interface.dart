import 'package:it_job_mobile/models/entity/certificate.dart';
import 'package:it_job_mobile/models/request/certificate_request.dart';

import '../../models/response/certificate_response.dart';
import '../../models/response/certificates_response.dart';

abstract class CertificatesInterface {
  Future<CertificatesResponse> searchCertificates(String url, String query, String skillGroupId);
  Future<CertificatesResponse> getCertificatesById(String url, String id);
    Future<CertificateResponse> postCertificate(
      String url, CertificateRequest request, String accessToken);
  Future<CertificateResponse> putCertificateById(
      String url, String id, Certificate request, String accessToken);
  Future<String> deleteCertificateById(
      String url, String id, String accessToken);
}
