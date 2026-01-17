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
  void _clearText() {
    setState(() {
      widget.controller.text == "";
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
            ? Border.all(color: AppColor.grey.withAlpha(200), width: 1.5)
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.isMultiline
            ? TextInputType.multiline
            : widget.keyboardType,
        maxLines: widget.isMultiline ? null : 1,
        minLines: widget.isMultiline ? 4 : 1,
        onChanged: (s) => setState(() => widget.onChanged?.call(s)),
        onEditingComplete: widget.onSubmit,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textHintStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: Icon(widget.icon, color: AppColor.grey),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: AppColor.grey),
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
