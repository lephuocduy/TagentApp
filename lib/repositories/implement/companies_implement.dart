import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:it_job_mobile/models/entity/company.dart';
import 'package:it_job_mobile/models/response/companies_response.dart';
import 'package:it_job_mobile/models/response/company_response.dart';

import '../../models/entity/paging.dart';
import '../interface/companies_interface.dart';

class CompaniesImplement implements CompaniesInterface {
  @override
  Future<CompanyResponse> getCompanyById(String url, String id) async {
    var result;
    try {
      Response response = await Dio().get(url + "/" + id);
      if (response.statusCode == 200) {
        result =
            CompanyResponse.companyResponseFromJson(jsonEncode(response.data));
      } else {
        result = CompanyResponse(
          code: 204,
          msg: "Not found",
          data: Company(
              id: '',
              email: '',
              phone: '',
              logo: '',
              website: '',
              status: 0,
              isPremium: false,
              name: '',
              description: '',
              companyType: 1),
        );
      }
    } on DioError catch (e) {
      log('Error getCompanyById: $e');
      result = CompanyResponse(
        code: 204,
        msg: "Not found",
        data: Company(
            id: '',
            email: '',
            phone: '',
            logo: '',
            website: '',
            status: 0,
            isPremium: false,
            name: '',
            description: '',
            companyType: 1),
      );
    }
    return result;
  }

  @override
  Future<CompaniesResponse> getCompanies(String url) async {
    var result;
    try {
      Response response = await Dio().get(url);
      if (response.statusCode == 200) {
        result = CompaniesResponse.companiesResponseFromJson(
            jsonEncode(response.data));
      } else {
        result = CompaniesResponse(
          code: 204,
          paging: Paging(page: 1, size: 50, total: 0),
          msg: "Not found",
          data: [],
        );
      }
    } on DioError catch (e) {
      log('Error getCompanies: $e');
      result = CompaniesResponse(
        code: 204,
        paging: Paging(page: 1, size: 50, total: 0),
        msg: "Not found",
        data: [],
      );
    }
    return result;
  }
}
