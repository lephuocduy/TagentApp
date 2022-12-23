import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_color.dart';

void showToastSuccess(String mess) => Fluttertoast.showToast(
    msg: mess,
    backgroundColor: AppColor.success,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 3);
void showToastFail(String mess) => Fluttertoast.showToast(
    msg: mess,
    backgroundColor: AppColor.red,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 3);
void showToastBonus(String mess) => Fluttertoast.showToast(
    msg: mess,
    textColor: AppColor.black,
    fontSize: 20,
    backgroundColor: Colors.greenAccent,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 3);
void showToastMinus(String mess) => Fluttertoast.showToast(
    msg: mess,
    textColor: AppColor.black,
    fontSize: 20,
    backgroundColor: Colors.redAccent,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 3);
void cancelToast() => Fluttertoast.cancel();
