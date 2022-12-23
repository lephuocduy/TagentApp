import 'package:flutter/material.dart';

import '../../constants/app_text_style.dart';

class AlreadyHaveAPasswordCheck extends StatelessWidget {
  final bool forgot;
  final Function() press;
  const AlreadyHaveAPasswordCheck({
    Key? key,
    this.forgot = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          forgot ? "Quên mật khẩu? " : "Bạn đã nhớ mật khẩu? ",
          style: AppTextStyles.h5Black,
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            forgot ? "Bấm vào đây" : "Đăng nhập",
            style: AppTextStyles.h5darkBlue,
          ),
        ),
      ],
    );
  }
}
