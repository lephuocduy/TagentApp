import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/applicant.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../repositories/implement/applicants_implement.dart';
import '../../repositories/implement/wallet_implement.dart';
import '../../shared/applicant_preferences.dart';
import '../../constants/url_api.dart';

class ApplicantProvider with ChangeNotifier {
  bool isLoad = false;
  bool checkExistChat = false;
  Applicant applicant = Applicant(
    id: '',
    phone: '',
    email: '',
    name: '',
    avatar: '',
    gender: 2,
    dob: DateTime.now(),
    address: '',
    earnMoney: 0,
  );

  void getApplicant() async {
    await ApplicantsImplement()
        .getApplicantById(UrlApi.applicant,
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
        .then((value) async => {applicant = value.data!});
    notifyListeners();
  }

  double wallet = 0;
  void getWallet() async {
    if (applicant.earnMoney == 1) {
      await WalletImplement()
          .wallet(UrlApi.wallet,
              Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
          .then((value) => {
                wallet = value.data[0].balance,
              });
      notifyListeners();
    }
  }

  Future<void> getWalletAsync() async {
    if (applicant.earnMoney == 1) {
      await WalletImplement()
          .wallet(UrlApi.wallet,
              Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
          .then((value) => {
                wallet = value.data[0].balance,
              });
      notifyListeners();
    }
  }
}
