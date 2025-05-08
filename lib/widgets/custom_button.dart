import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTapped;
  final bool loading;
  final Widget? prefix;
  final bool setBorderRadius;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTapped,
    this.loading = false,
    this.prefix,
    this.setBorderRadius = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle baseStyle = ElevatedButton.styleFrom(
      minimumSize: Size(width ?? double.infinity, height ?? 48),
      shape: setBorderRadius
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )
          : const RoundedRectangleBorder(),
    );

    return ElevatedButton(
      onPressed: loading ? null : onTapped,
      style: baseStyle,
      child: loading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefix != null) ...[
                  prefix!,
                  const SizedBox(width: 8),
                ],
                Text(text),
              ],
            ),
    );
  }
}
