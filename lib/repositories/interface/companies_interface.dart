import 'package:it_job_mobile/models/response/company_response.dart';

import '../../models/response/companies_response.dart';

abstract class CompaniesInterface {
  Future<CompanyResponse> getCompanyById(String url, String id);
  Future<CompaniesResponse> getCompanies(String url);
}