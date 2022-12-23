import 'package:flutter/material.dart';

import '../../constants/app_text_style.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function() press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Bạn chưa có tài khoản? " : "Bạn đã có tài khoản? ",
          style: AppTextStyles.h5Black,
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Đăng ký" : "Đăng nhập",
            style: AppTextStyles.h5darkBlue,
          ),
        ),
      ],
    );
  }
}
