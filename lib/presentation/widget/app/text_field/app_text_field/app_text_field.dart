import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/style/style.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Function(String)? onChanged;
  final VoidCallback? onSubmit;
  final bool seeBorder;
  final TextInputType keyboardType;
  final bool isMultiline;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.onChanged,
    this.onSubmit,
    this.seeBorder = false,
    this.keyboardType = TextInputType.text,
    this.isMultiline = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _clearText() {
    setState(() {
      widget.controller.clear();
      widget.onChanged?.call('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.white,
        boxShadow: widget.seeBorder
            ? null
            : [textFieldShadow.copyWith(blurRadius: 2)],
        border: widget.seeBorder
            ? Border.all(
                color: _focusNode.hasFocus
                    ? AppColor.red
                    : AppColor.grey.withAlpha(200),
                width: 1.5,
              )
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,

        keyboardType: widget.isMultiline
            ? TextInputType.multiline
            : widget.keyboardType,

        maxLines: widget.isMultiline ? null : 1,
        minLines: widget.isMultiline ? 4 : 1,

        onChanged: (s) {
          setState(() {
            widget.onChanged?.call(s);
          });
        },

        onEditingComplete: widget.onSubmit,

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textHintStyle,
          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          /// Иконка меняет цвет при фокусе
          prefixIcon: Icon(
            widget.icon,
            color: _focusNode.hasFocus ? AppColor.red : AppColor.grey,
          ),

          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppColor.grey),
                  onPressed: _clearText,
                  splashRadius: 20,
                )
              : null,
        ),

        style: textFieldStyle,
        cursorColor: AppColor.red,
      ),
    );
  }
}
