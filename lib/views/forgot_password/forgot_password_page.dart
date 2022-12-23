import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/repositories/implement/applicants_implement.dart';
import 'package:it_job_mobile/widgets/button/button.dart';
import 'package:it_job_mobile/widgets/input/input_field.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/route.dart';
import '../../repositories/implement/auth_implement.dart';
import '../../constants/url_api.dart';
import '../../views/forgot_password/already_have_a_password_check.dart';
import '../pages/otp_validation_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _phone = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SingleChildScrollView(
        child: SizedBox(
          height: 100.h,
          width: 100.h,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quên Mật Khẩu",
                          style: AppTextStyles.h2Black,
                        ),
                        Text(
                          "Nhập số điện thoại mà bạn muốn lấy lại mật khẩu",
                          style: AppTextStyles.h4Grey,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Form(
                      key: formKey,
                      child: InputField(
                        hintText: "Số điện thoại",
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        controller: _phone,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value != null && value.length != 10) {
                            return "Số điện thoại phải là 10 số";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    AlreadyHaveAPasswordCheck(
                      forgot: false,
                      press: () {
                        Navigator.of(context).pushNamed(
                          RoutePath.signInRoute,
                        );
                      },
                    ),
                  ],
                ),
                ButtonDefault(
                    width: 80.w,
                    height: 7.h,
                    content: 'Tiếp Tục',
                    textStyle: AppTextStyles.h3White,
                    backgroundBtn: AppColor.btnColor,
                    voidCallBack: () {
                      final isValidForm = formKey.currentState!.validate();
                      if (isValidForm) {
                        ApplicantsImplement()
                            .checkPhone(UrlApi.applicant, _phone.text)
                            .then((value) => {
                                  if (value == "exist")
                                    {
                                      AuthImplement()
                                          .getOTP(UrlApi.SMS, _phone.text),
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return OTPValidationPage(
                                          phone: _phone.text,
                                        );
                                      })),
                                    }
                                });
                      }
                    }),
              ]),
        ),
      ),
    );
  }
}
