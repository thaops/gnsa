import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/text_star.dart';

class CustomDetailFlight extends StatelessWidget {
  final List<String> title;
  final List<String> value;
  final String flightDetail;
  const CustomDetailFlight(
      {super.key,
      required this.title,
      required this.value,
      required this.flightDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundTab,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: flightDetail,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          ...List.generate(title.length,
              (index) => TextStar(title: title[index], value: value[index])),
        ],
      ),
    );
  }
}
