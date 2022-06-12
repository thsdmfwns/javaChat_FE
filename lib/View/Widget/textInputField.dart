import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'textFieldModel.dart';

class TextInputField extends StatelessWidget {
  final double? width;
  final double? height;
  final TextFieldModel model;
  final Widget? checkButton;
  final bool isPassword;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  TextInputField(
      {Key? key,
      required this.model,
      this.checkButton,
      this.isPassword = false,
      this.width,
      this.height,
      this.crossAxisAlignment,
      this.mainAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  void onTextFieldChange(String text, TextFieldModel model) => model.text(text);

  Widget _buildWidget() {
    return Obx(
      () => Row(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width ?? Get.mediaQuery.size.width * 0.25,
            height: height ?? 70,
            child: TextField(
                obscureText: isPassword,
                enableSuggestions: !isPassword,
                autocorrect: !isPassword,
                onChanged: (text) => onTextFieldChange(text, model),
                controller: model.textEditingController,
                decoration: InputDecoration(
                  helperText: model.helpText,
                  errorText:
                      model.errorText.isNotEmpty ? model.errorText.value : null,
                  labelText: model.label,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                )),
          ),
          checkButton ?? Container(),
        ],
      ),
    );
  }
}
