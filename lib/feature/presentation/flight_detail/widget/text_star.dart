import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextRowTitleValue extends StatelessWidget {
  final String title;
  final String value;
  const TextRowTitleValue({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w300),
          SizedBox(width: 6.w),
          TextWidget(text: value, fontSize: 14, fontWeight: FontWeight.w400),
        ],
      ),
    );
  }
}
