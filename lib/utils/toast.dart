import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

class ToastUtil {
  static void success(BuildContext context, String message) {
    CherryToast.success(
      title: Text(message),
      animationType: AnimationType.fromTop,
      displayCloseButton: false,
      inheritThemeColors: true,
    ).show(context);
  }

  static void error(BuildContext context, String message) {
    CherryToast.error(
      title: Text(message),
      animationType: AnimationType.fromTop,
      displayCloseButton: false,
      inheritThemeColors: true,
    ).show(context);
  }
}