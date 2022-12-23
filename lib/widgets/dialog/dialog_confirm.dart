import 'package:flutter/material.dart';

class DialogConfirm extends StatelessWidget {
  const DialogConfirm({
    Key? key,
    required this.width,
    required this.height,
    required this.contentButton,
    required this.color,
    required this.backgroundBtn,
    required this.voidCallBack,
    required this.contentTitleDialog,
    required this.contentDialog,
  }) : super(key: key);
  final double width;
  final double height;
  final String contentButton;
  final Color color;
  final Color backgroundBtn;
  final VoidCallback voidCallBack;
  final String contentTitleDialog;
  final String contentDialog;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        child: Text(
          contentButton,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundBtn),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(contentTitleDialog),
                    content: Text(contentDialog),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close")),
                      TextButton(
                          onPressed: voidCallBack, child: const Text("Ok")),
                    ],
                  ));
        },
      ),
    );
  }
}
