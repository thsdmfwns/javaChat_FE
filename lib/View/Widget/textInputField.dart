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
  final VoidCallback? onSubmmit;
  final bool expand;

  const TextInputField(
      {Key? key,
      required this.model,
      this.checkButton,
      this.isPassword = false,
      this.width,
      this.height,
      this.crossAxisAlignment,
      this.mainAxisAlignment,
      this.onSubmmit,
      this.expand = false})
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
            width: width,
            height: height ?? 70,
            child: TextField(
                textInputAction: TextInputAction.go,
                obscureText: isPassword,
                enableSuggestions: !isPassword,
                autocorrect: !isPassword,
                onChanged: (text) => onTextFieldChange(text, model),
                onSubmitted: (text) => onSubmmit,
                controller: model.textEditingController,
                expands: expand,
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
