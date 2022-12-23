import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/request/sign_in_request.dart';
import 'package:it_job_mobile/views/sign_in/already_have_an_account_check.dart';
import 'package:it_job_mobile/providers/sign_in_provider.dart';
import 'package:proste_bezier_curve/proste_bezier_curve.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../constants/route.dart';
import '../../providers/post_provider.dart';
import '../../widgets/button/button.dart';
import '../../widgets/input/input_field.dart';
import '../../widgets/input/password_field.dart';
import '../forgot_password/already_have_a_password_check.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final signInProvider = Provider.of<SignInProvider>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      signInProvider.checkLogin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PostProvider>(context);
    final signInProvider = Provider.of<SignInProvider>(context);
    return Stack(children: [
      Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: AppColor.primary,
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30.h,
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
                          if (value != null && value.length != 10) {
                            return "Số điện thoại phải là 10 số";
                          } else {
                            return null;
                          }
                        },
                      ),
                      PasswordField(
                          hintText: "Mật khẩu",
                          textInputAction: TextInputAction.done,
                          controller: _password,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value != null && value.length < 8) {
                              return "Mật khẩu phải từ 8 kí tự trở lên";
                            } else {
                              return null;
                            }
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                AlreadyHaveAPasswordCheck(
                  press: () {
                    Navigator.of(context).pushNamed(
                      RoutePath.forgotPasswordRouter,
                    );
                  },
                ),
                SizedBox(
                  height: 2.h,
                ),
                Stack(alignment: Alignment.center, children: [
                  ButtonDefault(
                      width: 80.w,
                      height: 7.h,
                      content: signInProvider.isLoad ? '' : 'Đăng Nhập',
                      textStyle: AppTextStyles.h3White,
                      backgroundBtn: AppColor.darkLogo,
                      voidCallBack: () async {
                        final isValidForm = formKey.currentState!.validate();
                        if (isValidForm) {
                          signInProvider.signIn(
                              context,
                              SignInRequest(
                                phone: _phone.text,
                                password: _password.text,
                              ));
                        }
                      }),
                  if (signInProvider.isLoad)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        backgroundColor: AppColor.darkLogo,
                        strokeWidth: 3,
                        color: AppColor.white,
                      ),
                    )
                ]),
                SizedBox(
                  height: 2.h,
                ),
                const OrDivider(),
                SizedBox(
                  height: 2.h,
                ),
                AlreadyHaveAnAccountCheck(press: () {
                  setState(() {
                    Navigator.of(context).pushNamed(
                      RoutePath.signUpRouter,
                    );
                  });
                }),
              ],
            ),
          ),
        ),
      ),
      ClipPath(
        clipper: ProsteBezierCurve(
          position: ClipPosition.bottom,
          list: [
            BezierCurveSection(
              start: Offset(0, 260),
              top: Offset(100.w / 2, 300),
              end: Offset(100.w, 260),
            ),
          ],
        ),
        child: Scaffold(
          body: Container(
            width: 100.w,
            color: AppColor.logo,
            child: Column(
              children: [
                Image.asset(
                  ImagePath.logo,
                  fit: BoxFit.fill,
                  width: 75.w,
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.2.h),
      width: 80.w,
      child: Row(children: [
        Expanded(
          child: Divider(
            color: AppColor.darkBlue,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "HOẶC",
            style: AppTextStyles.h4Grey,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColor.darkBlue,
            height: 1,
          ),
        ),
      ]),
    );
  }
}
