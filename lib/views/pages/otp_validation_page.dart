import 'dart:async';
import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/views/forgot_password/change_new_password_page.dart';
import 'package:it_job_mobile/views/sign_in/sign_in_page.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../constants/toast.dart';
import '../../constants/app_text_style.dart';
import '../../repositories/implement/auth_implement.dart';
import '../../constants/url_api.dart';

class OTPValidationPage extends StatefulWidget {
  String phone;
  final bool forgot;
  OTPValidationPage({
    Key? key,
    required this.phone,
    this.forgot = true,
  }) : super(key: key);

  @override
  State<OTPValidationPage> createState() => _OTPValidationPageState();
}

class _OTPValidationPageState extends State<OTPValidationPage> {
  bool _isResendAgain = false;
  bool _isLoading = false;
  bool _onEditing = true;
  String _code = "";

  late Timer _time;
  int _start = 60;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _time = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });
    const oneSec = Duration(milliseconds: 5000);

    AuthImplement().verifyOTP(UrlApi.SMS, _code, widget.phone).then((value) => {
          _time = Timer.periodic(oneSec, (timer) {
            if (value.contains("Successful")) {
              setState(() {
                _isLoading = false;
              });
              if (!widget.forgot) {
                showToastSuccess("Đăng ký thành công");
              }
              widget.forgot
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return ChangeNewPasswordPage(
                        phone: widget.phone,
                        otp: _code,
                      );
                    }))
                  : Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                      return SignInPage();
                    }));
            } else {
              showToastFail("Mã OTP không đúng");
              setState(() {
                _isLoading = false;
              });
            }
            timer.cancel();
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
          child: SizedBox(
        width: 100.w,
        height: 100.h,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xác thực",
                    style: AppTextStyles.h2Black,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Chúng tôi đã gửi mã OTP đến số điện thoại của bạn",
                    style: AppTextStyles.h4Grey,
                  ),
                  Text(
                    "+84 *****" + widget.phone.substring(6),
                    style: AppTextStyles.h4Grey,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              VerificationCode(
                textStyle: AppTextStyles.h3Black,
                keyboardType: TextInputType.number,
                underlineColor: AppColor.black,
                length: 4,
                cursorColor: AppColor.black,
                onCompleted: (String value) {
                  setState(() {
                    _code = value;
                  });
                },
                onEditing: (bool value) {
                  setState(() {
                    _onEditing = value;
                  });
                  if (!_onEditing) FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Gửi lại mã OTP? ",
                    style: AppTextStyles.h5Black,
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthImplement().getOTP(UrlApi.SMS, widget.phone);
                      if (_isResendAgain) return;
                      resend();
                    },
                    child: Text(
                      _isResendAgain
                          ? "Hãy thử lại sau " + _start.toString()
                          : "Gửi lại",
                      style: AppTextStyles.h5darkBlue,
                    ),
                  )
                ],
              ),
            ],
          ),
          MaterialButton(
            disabledColor: AppColor.primary,
            onPressed: _code.length < 4
                ? null
                : () {
                    verify();
                  },
            color: AppColor.blue,
            minWidth: 80.w,
            height: 7.h,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  12,
                ),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: AppColor.white,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    "Verify",
                    style: AppTextStyles.h3White,
                  ),
          ),
        ]),
      )),
    );
  }
}
