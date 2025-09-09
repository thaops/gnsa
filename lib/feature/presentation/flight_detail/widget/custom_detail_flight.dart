import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/date_utils.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/text_star.dart';

class CustomDetailFlight extends StatelessWidget {
  final String flightDetail;
  final SupplyFormModel supplyFormModel;
  const CustomDetailFlight({
    super.key,
    required this.flightDetail,
    required this.supplyFormModel,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextRowTitleValue(
                      title: "Flight :",
                      value:
                          supplyFormModel.flightInfo?.routing.toString() ?? ''),
                  TextRowTitleValue(
                      title: "Flight No :",
                      value: supplyFormModel.flightInfo?.flightNo.toString() ??
                          ''),
                  TextRowTitleValue(
                      title: "Time :",
                      value: DateUtilsCustom.formatStringDate(supplyFormModel
                              .flightInfo?.departureDate
                              .toString() ??
                          '')),
                ],
              ),
              SizedBox(width: AppSizes.spacingMedium.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextRowTitleValue(
                      title: "Pk:", value: "${supplyFormModel.flightInfo?.pk}"),
                  TextRowTitleValue(
                      title: "A/C :",
                      value: "${supplyFormModel.flightInfo?.acfNo}"),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
