import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/style/style.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final Function(String)? onChanged;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late FocusNode _focusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {}); // обновление цвета иконки при фокусе
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _clearText() {
    widget.controller.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _focusNode.hasFocus
              ? AppColor.red
              : AppColor.grey.withAlpha(150),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword ? _obscureText : false,
        onChanged: widget.onChanged,
        cursorColor: AppColor.red,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textHintStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),

          /// Иконка слева
          prefixIcon: Icon(
            widget.icon,
            color: _focusNode.hasFocus ? AppColor.red : AppColor.grey,
          ),

          /// Очистка текста / показ пароля
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.grey,
                  ),
                  onPressed: _toggleObscure,
                )
              : (widget.controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppColor.grey),
                        onPressed: _clearText,
                      )
                    : null),
        ),
        style: textFieldStyle,
      ),
    );
  }
}
