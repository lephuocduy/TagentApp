import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/block.dart';
import 'package:it_job_mobile/models/entity/company.dart';
import 'package:it_job_mobile/repositories/implement/blocks_implement.dart';
import 'package:it_job_mobile/repositories/implement/companies_implement.dart';
import 'package:it_job_mobile/constants/url_api.dart';

import '../shared/applicant_preferences.dart';
import '../views/profile/profile_setting/profile_blocked/view_company_blocked_page.dart';



class BlockProvider extends ChangeNotifier {
  List<Block> blockedList = [];
  List<Company> companies = [];

  void getBlockedList(BuildContext context, String id) async {
    await CompaniesImplement()
        .getCompanies(UrlApi.companies)
        .then((value) => companies = value.data);
    BlocksImplement().getBlockedList(UrlApi.blocks, id).then((value) async => {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ViewCompanyBlockedPage(
              blockedList: value.data,
              companies: companies,
            );
          }))
        });
  }

  void unBlock(
      BuildContext context, String applicantId, String companyUnblockId) {
    BlocksImplement().unBlock(UrlApi.blocks, companyUnblockId, ApplicantPreferences.getToken(''),);
    getBlockedList(context, applicantId);
  }
}
