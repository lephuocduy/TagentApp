import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_text_style.dart';

class EditField extends StatelessWidget {
  final VoidCallback onClicked;
  final IconData icon;
  final String hintText;
  final String text;

  const EditField(
      {Key? key,
      required this.onClicked,
      required this.icon,
      required this.hintText,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onClicked,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        icon,
                        size: 25,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Text(
                        hintText,
                        style: AppTextStyles.h3Black,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        text,
                        style: AppTextStyles.h3Black,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: AppColor.grey,
                height: 2.h,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3.h,
        )
      ],
    );
  }
}
