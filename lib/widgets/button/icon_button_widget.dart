import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_text_style.dart';

class IconButtonWidget extends StatelessWidget {
  final String text;
  final Icon icon;
  final double size;
  final VoidCallback onClicked;
  const IconButtonWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.size,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.grey,
                blurRadius: 5,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: size,
            backgroundColor: AppColor.white,
            child: IconButton(
              onPressed: onClicked,
              icon: icon,
              color: Colors.black,
              splashRadius: size,
            ),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          text,
          style: AppTextStyles.h5darkGrey,
        )
      ],
    );
  }
}
