import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/repositories/implement/profile_applicants_implement.dart';
import 'package:it_job_mobile/views/profile/profile_common/edit_profile_page.dart';
import 'package:it_job_mobile/providers/applicant_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';

import '../../constants/toast.dart';
import '../../models/request/sign_in_request.dart';
import '../../repositories/implement/auth_implement.dart';
import '../../shared/applicant_preferences.dart';
import '../../views/bottom_tab_bar/bottom_tab_bar.dart';
import '../../views/pages/otp_validation_page.dart';
import '../../constants/url_api.dart';

class SignInProvider extends ChangeNotifier {
  bool isLoad = false;

  void signIn(BuildContext context, SignInRequest request) async {
    isLoad = true;
    notifyListeners();
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    Map<String, dynamic> payload;
    await AuthImplement().signIn(UrlApi.signIn, request).then((value) async => {
          if (value.token!.isNotEmpty)
            {
              if (value.token == 'verify')
                {
                  AuthImplement().getOTP(UrlApi.SMS, request.phone),
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OTPValidationPage(
                      phone: request.phone,
                      forgot: false,
                    );
                  })),
                }
              else
                {
                  await ApplicantPreferences.setToken(value.token!),
                  payload = Jwt.parseJwt(value.token.toString()),
                  if (payload['role'].toString() == "APPLICANT")
                    {
                      saveTokenChat(payload['Id'].toString()),
                      applicantProvider.getApplicant(),
                      await ProfileApplicantsImplement()
                          .getProfileApplicantsById(
                            UrlApi.profileApplicants,
                            Jwt.parseJwt(
                                    ApplicantPreferences.getToken(''))['Id']
                                .toString(),
                          )
                          .then((value) async => {
                                if (value.data.isEmpty)
                                  {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditProfilePage(
                                        applicant: applicantProvider.applicant,
                                        update: false,
                                      );
                                    })),
                                  }
                                else
                                  {
                                    detailProfileProvider.profileApplicants =
                                        value.data,
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomTabBar()),
                                        (route) => false),
                                  }
                              }),
                    }
                  else
                    {
                      showToastFail(
                          "Số điện thoại này không có quyền đăng nhập"),
                    }
                }
            }
        });
    isLoad = false;
    notifyListeners();
  }

  void checkLogin(BuildContext context) async {
    final applicantProvider =
        Provider.of<ApplicantProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    String token = ApplicantPreferences.getToken('');
    if (token.isNotEmpty) {
      applicantProvider.getApplicant();
      await ProfileApplicantsImplement()
          .getProfileApplicantsById(
            UrlApi.profileApplicants,
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString(),
          )
          .then((value) async => {
                if (value.data.isEmpty)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditProfilePage(
                        applicant: applicantProvider.applicant,
                        update: false,
                      );
                    })),
                  }
                else
                  {
                    detailProfileProvider.profileApplicants = value.data,
                    await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => BottomTabBar()),
                        (route) => false),
                  }
              });
    }
  }

  void saveTokenChat(String id) async {
    await FirebaseMessaging.instance.getToken().then((token) async => {
          await FirebaseFirestore.instance
              .collection("userTokens")
              .doc(id)
              .set({'token': token}),
        });
  }
}
