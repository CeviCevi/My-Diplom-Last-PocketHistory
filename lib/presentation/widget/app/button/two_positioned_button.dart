import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';

class TwoPositionButton extends StatefulWidget {
  final String leftLabel;
  final String rightLabel;
  final ValueChanged<bool>? onChanged;

  const TwoPositionButton({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    this.onChanged,
  });

  @override
  State<TwoPositionButton> createState() => _TwoPositionButtonState();
}

class _TwoPositionButtonState extends State<TwoPositionButton> {
  bool isRight = false;

  void toggle() {
    setState(() => isRight = !isRight);
    widget.onChanged?.call(isRight);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: .center,
          children: [
            /// Левая кнопка
            GestureDetector(
              onTap: () {
                if (isRight) toggle();
              },
              child: AnimatedContainer(
                width: MediaQuery.of(context).size.width / 2.5,
                duration: Duration(milliseconds: 100),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isRight ? Colors.transparent : AppColor.red,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
                child: Text(
                  widget.leftLabel,
                  textAlign: .center,
                  style: TextStyle(
                    color: isRight ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Правая кнопка
            GestureDetector(
              onTap: () {
                if (!isRight) toggle();
              },
              child: AnimatedContainer(
                width: MediaQuery.of(context).size.width / 2.5,
                duration: Duration(milliseconds: 100),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isRight ? AppColor.red : Colors.transparent,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                child: Text(
                  widget.rightLabel,
                  textAlign: .center,
                  style: TextStyle(
                    color: isRight ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
