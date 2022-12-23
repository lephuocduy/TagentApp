import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';

import '../../constants/app_text_style.dart';

class DismissibleWidget<T> extends StatelessWidget {
  final T item;
  final Widget child;
  final DismissDirectionCallback onDismissed;
  bool isProfile;
  DismissibleWidget({
    Key? key,
    required this.item,
    required this.child,
    required this.onDismissed,
    this.isProfile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: buildSwipeActionLeft(),
      secondaryBackground:
          isProfile ? buildSwipeActionRightProfile() : buildSwipeActionRight(),
      child: child,
      onDismissed: onDismissed,
    );
  }

  Widget buildSwipeActionLeft() => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: AppColor.success,
        child: Icon(
          Icons.archive_sharp,
          color: AppColor.white,
          size: 30,
        ),
      );

  Widget buildSwipeActionRight() => Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: AppColor.red,
      child: Text(
        "Xoá tin nhắn",
        style: AppTextStyles.h4White,
      ));

  Widget buildSwipeActionRightProfile() => Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 20),
      color: AppColor.red,
      child: Text(
        "Xoá hồ sơ",
        style: AppTextStyles.h4White,
      ));
}
