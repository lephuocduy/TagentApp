import 'package:flutter/material.dart';
import 'package:it_job_mobile/repositories/implement/auth_implement.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../../../constants/app_text_style.dart';
import '../../../../shared/applicant_preferences.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/input/password_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();
  bool _isNewPasswordEightCharacters = false;
  bool _hasNewPasswordOneNumber = false;
  bool _matchingPassword = false;
  final formKey = GlobalKey<FormState>();

  onNewPasswordChange(String newPassword) {
    final numericRegex = RegExp(r'[0-9]');
    setState(
      () {
        _isNewPasswordEightCharacters = false;
        if (newPassword.length >= 8) _isNewPasswordEightCharacters = true;
        _hasNewPasswordOneNumber = false;
        if (numericRegex.hasMatch(newPassword)) _hasNewPasswordOneNumber = true;
        _confirmNewPassword.clear();
      },
    );
  }

  onMatchingPassword(String password) {
    setState(
      () {
        _matchingPassword = false;
        if (_newPassword.text == _confirmNewPassword.text &&
            _oldPassword.text != _newPassword.text) {
          _matchingPassword = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColor.black,
        ),
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '?????i M???t Kh???u',
          style: AppTextStyles.h3Black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColor.primary,
          height: 100.h,
          width: 100.h,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      PasswordField(
                        hintText: "M???t kh???u c??",
                        textInputAction: TextInputAction.next,
                        controller: _oldPassword,
                        onChanged: (value) {
                          _newPassword.clear();
                          _confirmNewPassword.clear();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "M???t kh???u kh??ng ???????c ????? tr???ng";
                          } else {
                            return null;
                          }
                        },
                      ),
                      PasswordField(
                        hintText: "M???t kh???u m???i",
                        textInputAction: TextInputAction.next,
                        controller: _newPassword,
                        onChanged: (newPassword) =>
                            onNewPasswordChange(newPassword),
                        validator: null,
                      ),
                      PasswordField(
                        hintText: "Nh???p l???i m???t kh???u m???i",
                        textInputAction: TextInputAction.done,
                        controller: _confirmNewPassword,
                        onChanged: (password) => onMatchingPassword(password),
                        validator: null,
                      ),
                      SizedBox(
                        height: 5.w,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _isNewPasswordEightCharacters
                                        ? AppColor.success
                                        : Colors.transparent,
                                    border: _isNewPasswordEightCharacters
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: AppColor.grey,
                                          ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: AppColor.primary,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                const Text("M???t kh???u ph???i t??? 8 k?? t??? tr??? l??n"),
                              ],
                            ),
                            SizedBox(
                              height: 2.w,
                            ),
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _hasNewPasswordOneNumber
                                        ? AppColor.success
                                        : Colors.transparent,
                                    border: _hasNewPasswordOneNumber
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: AppColor.grey,
                                          ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: AppColor.primary,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                const Text(
                                    "M???t kh???u ph???i ch???a ??t nh???t 1 con s???"),
                              ],
                            ),
                            SizedBox(
                              height: 2.w,
                            ),
                            Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: _matchingPassword
                                        ? AppColor.success
                                        : Colors.transparent,
                                    border: _matchingPassword
                                        ? Border.all(color: Colors.transparent)
                                        : Border.all(
                                            color: AppColor.grey,
                                          ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: AppColor.primary,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                const Text(
                                    "M???t kh???u nh???p l???i ph???i kh???p v???i m???t kh???u \nv?? ph???i kh??c v???i m???t kh???u c??"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonDefault(
                  width: 80.w,
                  height: 7.h,
                  content: '?????i m???t kh???u',
                  textStyle: AppTextStyles.h3White,
                  backgroundBtn: AppColor.btnColor,
                  voidCallBack: () async {
                    final isValidForm = formKey.currentState!.validate();
                    if (isValidForm &&
                        _isNewPasswordEightCharacters &&
                        _hasNewPasswordOneNumber &&
                        _matchingPassword) {
                      AuthImplement()
                          .changePassword(
                            UrlApi.applicant,
                            Jwt.parseJwt(
                                    ApplicantPreferences.getToken(''))['Id']
                                .toString(),
                            _oldPassword.text,
                            _newPassword.text,
                            ApplicantPreferences.getToken(''),
                          )
                          .then((value) async => {
                                if (value == "Successful")
                                  {
                                    await Future.delayed(
                                        const Duration(milliseconds: 2000)),
                                    Navigator.pop(context),
                                  }
                              });
                    }
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
