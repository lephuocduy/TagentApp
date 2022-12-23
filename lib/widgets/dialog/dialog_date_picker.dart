import 'package:flutter/cupertino.dart';
import 'package:it_job_mobile/constants/app_text_style.dart';

class DialogDatePicker {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();

  static void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              'Chọn',
              style: AppTextStyles.h2Black,
            ),
            onPressed: onClicked,
          ),
        ),
      );
}
