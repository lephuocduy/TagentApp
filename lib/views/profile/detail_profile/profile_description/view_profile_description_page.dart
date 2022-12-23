import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:it_job_mobile/constants/app_color.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../providers/detail_profile_provider.dart';

class ViewProfileDescriptionPage extends StatelessWidget {
  int selectedIndex;
  ViewProfileDescriptionPage({
    Key? key,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DetailProfileProvider detailProfileProvider =
        Provider.of<DetailProfileProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Row(
            children: [
              const Icon(
                Iconsax.user,
                size: 25,
              ),
              SizedBox(
                width: 1.w,
              ),
              Text(
                "Giới thiệu bản thân",
                style: AppTextStyles.h3Black,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          color: AppColor.white,
          child: Padding(
            padding: EdgeInsets.only(
              left: 5.w,
              right: 5.w,
              top: 3.w,
              bottom: 3.w,
            ),
            child: selectedIndex == 1
                ? TextFormField(
                    autofocus: false,
                    controller: detailProfileProvider.controllerDescription,
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    maxLength: 200,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.h4Black,
                  )
                : detailProfileProvider.controllerDescription.text.isNotEmpty
                    ? SizedBox(
                        height: 10.h,
                        width: 100.w,
                        child: Text(
                          detailProfileProvider.controllerDescription.text,
                          style: AppTextStyles.h4Black,
                        ))
                    : Container(
                        height: 2.h,
                      ),
          ),
        )
      ],
    );
  }
}
