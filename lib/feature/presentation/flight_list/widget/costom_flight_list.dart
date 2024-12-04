import 'package:flutter/material.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class CustomFightList extends StatelessWidget {
  const CustomFightList({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.backgroundTab,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: "Hà Nội",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      TextWidget(
                        text: "12:42",
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const TextWidget(
                        text: "VN7563",
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Image.asset(Img.iconFlight),
                      ),
                      const TextWidget(
                        text: "15 Aug",
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      TextWidget(
                        text: "Hà Nội",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      TextWidget(
                        text: "12:42",
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
