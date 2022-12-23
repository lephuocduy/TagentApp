import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/app_color.dart';

class SearchWidget extends StatefulWidget {
  String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.search,
      controller: controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 15),
        prefixIcon: Icon(
          Iconsax.search_normal,
          color: widget.text.isEmpty ? AppColor.darkGrey : AppColor.black,
          size: 20,
        ),
        suffixIcon: widget.text.isNotEmpty
            ? GestureDetector(
                child: Icon(
                  Icons.close,
                  color: AppColor.black,
                ),
                onTap: () {
                  widget.text = '';
                  controller.clear();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )
            : null,
        hintText: widget.hintText,
        filled: true,
        fillColor: AppColor.white,
        border: InputBorder.none,
      ),
    );
  }
}
