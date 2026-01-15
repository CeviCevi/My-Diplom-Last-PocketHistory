import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/style/style.dart';

class CastleTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool searhObj;
  final Function? searchNewObj;
  final Function? backToMainMenu;
  final EdgeInsetsGeometry padding;

  const CastleTextField({
    super.key,
    required this.controller,
    this.hintText = "Найти достопримечательность",
    this.padding = const .symmetric(horizontal: 20, vertical: 10),
    this.onChanged,
    this.backToMainMenu,
    this.searchNewObj,
    this.searhObj = false,
  });

  @override
  State<CastleTextField> createState() => _CastleTextFieldState();
}

class _CastleTextFieldState extends State<CastleTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _clearText() {
    widget.controller.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.white,
                boxShadow: [textFieldShadow],
              ),
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged,
                onEditingComplete: () => widget.searchNewObj?.call(),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: textHintStyle,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixIcon: Icon(Icons.castle_outlined, color: AppColor.grey),
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
            ),
          ),
          GestureDetector(
            onTap: () {
              _clearText.call();
              widget.backToMainMenu?.call();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(left: widget.searhObj ? 20 : 0),
              width: widget.searhObj ? 52 : 0,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.white,
                boxShadow: [textFieldShadow],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.searhObj
                    ? Icon(Icons.home_outlined, color: AppColor.red)
                    : const Center(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
