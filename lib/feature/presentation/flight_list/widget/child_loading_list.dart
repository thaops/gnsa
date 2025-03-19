import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChildLoadingList extends StatelessWidget {
  final Widget child;
  const ChildLoadingList({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.h,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: child,
          )),
    );
  }
}
