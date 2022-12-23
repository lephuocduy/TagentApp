import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../constants/route.dart';
import '../../models/request/sign_up_request.dart';
import '../../repositories/implement/auth_implement.dart';
import '../../constants/url_api.dart';
import '../../widgets/button/button.dart';
import '../../widgets/input/input_field.dart';
import '../../widgets/input/password_field.dart';
import '../pages/otp_validation_page.dart';
import '../sign_in/already_have_an_account_check.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
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
        _confirmPassword.clear();
      },
    );
  }

  onMatchingPassword(String password) {
    setState(
      () {
        _matchingPassword = false;
        if (_password.text == _confirmPassword.text) {
          _matchingPassword = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Đăng Ký',
          style: AppTextStyles.h3Black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 100.h,
          color: AppColor.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Image.asset(
                    ImagePath.create,
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        InputField(
                          hintText: "Số điện thoại",
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          controller: _phone,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Số điện thoại không được trống";
                            } else if (value != null && value.length != 10) {
                              return "Số điện thoại phải là 10 số";
                            } else {
                              return null;
                            }
                          },
                        ),
                        InputField(
                          hintText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: _email,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Email không được trống";
                            } else if (value != null &&
                                !RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$')
                                    .hasMatch(value)) {
                              return "Email không đúng định dạng";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  PasswordField(
                    hintText: "Mật khẩu",
                    textInputAction: TextInputAction.next,
                    controller: _password,
                    onChanged: (newPassword) =>
                        onNewPasswordChange(newPassword),
                    validator: null,
                  ),
                  PasswordField(
                    hintText: "Nhập lại mật khẩu",
                    textInputAction: TextInputAction.done,
                    controller: _confirmPassword,
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
                            const Text("Mật khẩu phải từ 8 kí tự trở lên"),
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
                            const Text("Mật khẩu phải chứa ít nhất 1 con số"),
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
                                "Mật khẩu nhập lại phải khớp với mật khẩu"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ButtonDefault(
                      width: 80.w,
                      height: 7.h,
                      content: 'Đăng Kí',
                      textStyle: AppTextStyles.h3White,
                      backgroundBtn: AppColor.btnColor,
                      voidCallBack: () {
                        final isValidForm = formKey.currentState!.validate();

                        if (isValidForm &&
                            _isNewPasswordEightCharacters &&
                            _hasNewPasswordOneNumber &&
                            _matchingPassword) {
                          AuthImplement()
                              .signUp(
                                  UrlApi.applicant,
                                  SignUpRequest(
                                      phone: _phone.text,
                                      password: _password.text,
                                      email: _email.text))
                              .then((value) => {
                                    if (value.data!.phone != "exist")
                                      {
                                        AuthImplement()
                                            .getOTP(UrlApi.SMS, _phone.text),
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return OTPValidationPage(
                                            phone: _phone.text,
                                            forgot: false,
                                          );
                                        })),
                                      }
                                  });
                        }
                      }),
                  SizedBox(
                    height: 2.h,
                  ),
                  AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        setState(() {
                          Navigator.of(context).pushNamed(
                            RoutePath.signInRoute,
                          );
                        });
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
