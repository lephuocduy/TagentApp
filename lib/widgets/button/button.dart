import 'package:flutter/material.dart';
import 'package:it_job_mobile/constants/app_color.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault({
    Key? key,
    required this.width,
    required this.height,
    required this.content,
    required this.textStyle,
    required this.backgroundBtn,
    required this.voidCallBack,
  }) : super(key: key);
  final double width;
  final double height;
  final String content;
  final TextStyle textStyle;
  final Color backgroundBtn;
  final VoidCallback voidCallBack;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: voidCallBack,
        child: Text(
          content,
          style: textStyle,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundBtn),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
