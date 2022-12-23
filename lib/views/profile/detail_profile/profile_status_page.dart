import 'package:flutter/material.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_text_style.dart';

class ProfileStatusPage extends StatefulWidget {
  ProfileStatusPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileStatusPage> createState() => _ProfileStatusPageState();
}

class _ProfileStatusPageState extends State<ProfileStatusPage> {
  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hồ Sơ Đang ' + (detailProfileProvider.status! ? 'Bật' : 'Ẩn'),
          style: AppTextStyles.h3Black,
        ),
        SizedBox(
          width: 2.w,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Transform.scale(
            scale: 1.1,
            child: Switch.adaptive(
              activeColor: AppColor.black,
              value: detailProfileProvider.statusValue,
              onChanged: (value) => {
                detailProfileProvider.status = !detailProfileProvider.status!,
                setState(
                  () => detailProfileProvider.statusValue = value,
                ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
