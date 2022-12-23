import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_image_path.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:it_job_mobile/widgets/button/button.dart';
import 'package:sizer/sizer.dart';

import '../../constants/route.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.white,
        width: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Chúng tôi sẽ giúp bạn được chú ý, phỏng vấn và nhận công việc!",
              textAlign: TextAlign.center,
              style: AppTextStyles.h2Black,
            ),
            Image.asset(
              ImagePath.onboarding,
            ),
            ButtonDefault(
                width: 80.w,
                height: 7.h,
                content: "Bắt Đầu",
                textStyle: AppTextStyles.h3White,
                backgroundBtn: AppColor.btnColor,
                voidCallBack: () {
                  Navigator.of(context).pushNamed(
                    RoutePath.signInRoute,
                  );
                })
          ],
        ),
      ),
    );
  }
}
