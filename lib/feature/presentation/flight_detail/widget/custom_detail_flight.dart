import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/text_star.dart';

class CustomDetailFlight extends StatelessWidget {
  final String flightDetail;
  final FlightDetailModel flightDetailModel;
  const CustomDetailFlight({
    super.key,
    required this.flightDetail,
    required this.flightDetailModel,
  });

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
          TextStar(title: "Chuyến bay :", value: flightDetailModel.flightNo.toString()),
          TextStar(title: "Số hiệu :", value: flightDetailModel.routing.toString()),
          TextStar(title: "Giờ bay", value: flightDetailModel.actualTimeArrival.toString()),
        ],
      ),
    );
  }
}
