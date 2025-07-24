import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final int itemCount;
  final Widget child;

  const LoadingShimmer({super.key, required this.child, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    var shimmer = Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: child,
    );
    return itemCount > 1 ? ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium.h),
          child: shimmer,
        );
      },
    ) : shimmer;
  }
}


