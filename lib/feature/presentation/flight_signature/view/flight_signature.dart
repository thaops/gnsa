import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart' show AppBarWidget;
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class FlightSignature extends ConsumerWidget {
  const FlightSignature({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Xác nhận',
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenSize.height,
          width: screenSize.width,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSignature(
                title: 'TIẾP VIÊN XÁC NHẬN',
                onPressed: () {
                  context.push(AppRouter.flightSign, extra: "TIẾP VIÊN XÁC NHẬN");
                },
                onEditPressed: () {
                  context.push(AppRouter.flightSign, extra: "TIẾP VIÊN XÁC NHẬN");
                },
                imageUrl: 'https://chukydep.vn/Upload/post/chu-ky-ten-chi.jpg',
              ),
              CustomSignature(
                title: 'NHÂN VIÊN XÁC NHẬN',
                onPressed: () {
                  context.push(AppRouter.flightSign, extra: "NHÂN VIÊN XÁC NHẬN");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
