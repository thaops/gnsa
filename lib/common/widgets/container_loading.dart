import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerLoading extends StatelessWidget {
  final double? height;
  const ContainerLoading({super.key , this.height = 104});

  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
              height: height?.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade400,
              ),
            );
  }
}