import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TextFieldModel {
  final TextEditingController textEditingController;
  final String label;
  RxString text = ''.obs;
  RxString errorText = ''.obs;
  final String? helpText;

  TextFieldModel({
    required this.label,
    required this.textEditingController,
    this.helpText,
  });

  void clearText() {
    text('');
    errorText('');
    textEditingController.clear();
  }
}
