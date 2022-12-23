import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_text_style.dart';

class TextFieldWidget extends StatefulWidget {
  final TextInputType keyboardType;
  final IconData icon;
  final String label;
  final String text;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    required this.keyboardType,
    required this.icon,
    required this.label,
    required this.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 25,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  SizedBox(
                    width: 15.w,
                    child: Text(
                      widget.label,
                      style: AppTextStyles.h3Black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 57.w,
                height: 3.1.h,
                child: TextField(
                  keyboardType: widget.keyboardType,
                  controller: controller,
                  textAlign: TextAlign.right,
                  style: controller.text.length < 15
                      ? AppTextStyles.h3Black
                      : AppTextStyles.h4Black,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
              const Icon(
                Icons.edit,
                size: 20,
              ),
            ],
          ),
          Divider(
            color: AppColor.grey,
            height: 2.h,
          ),
        ],
      );
}
