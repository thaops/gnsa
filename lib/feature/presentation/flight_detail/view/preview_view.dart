import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/dash_line.dart';
import 'package:gnsa/common/utils/date_utils.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_preview_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_loading_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

const double _maxWidth = 400;
const double _heightDivider = 2;
const double _dashHeight = 1;
const double _dashWidth = 5;
const double _dashSpace = 3;

class PreviewView extends ConsumerWidget {
  final PreviewArgs args;
  const PreviewView({super.key, required this.args});

  void handlePrint() {
    print('Printing supply form...');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightState = ref.watch(flightPreviewProviderProvider(args));
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Xem trước',
      ),
      body: flightState.when(
        data: (data) => _buildPreviewBody(data, context),
        loading: () => LoadingShimmer(
          child: CustomLoadingCase(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }

  SingleChildScrollView _buildPreviewBody(
      FlightPreviewModel data, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingSmall),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: AppColors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildFlightInfoRow(
                              label: 'Flight',
                              value: data.flightInfo?.routing ?? ''),
                          _buildFlightInfoRow(
                              label: 'Flight No',
                              value: data.flightInfo?.flightNo ?? ''),
                          _buildFlightInfoRow(
                              label: 'Aircraft',
                              value: data.flightInfo?.acfNo ?? ''),
                          _buildFlightInfoRow(
                              label: 'Departure',
                              value: DateUtilsCustom.formatStringDate(
                                  data.flightInfo?.departureDate ?? '')),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSizes.paddingMedium),
                    Expanded(
                      child: Column(
                        children: [
                          _buildFlightInfoRow(
                              label: 'Arrival',
                              value: DateUtilsCustom.formatStringDate(
                                  data.flightInfo?.arrivalDate ?? '')),
                          _buildFlightInfoRow(
                              label: 'Aircraft Type',
                              value: data.flightInfo?.typeApl ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.paddingXSmall),
              _buildFlightInfoRow(
                  label: 'Tên',
                  value: 'SL',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Divider(
                height: _heightDivider,
                color: AppColors.black,
              ),
              SizedBox(height: AppSizes.paddingXSmall),
              ...data.supplyFormDetails?.map((supply) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppSizes.paddingMedium),
                      child: Container(
                        color: AppColors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFlightInfoRow(
                                label: supply.supplyType ?? '',
                                value: supply.supplyCode ?? '',
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween),
                            SizedBox(height: AppSizes.paddingSmall),
                            ...supply.detailItems?.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSizes.paddingSmall),
                                    child: Column(
                                      children: [
                                        _buildFlightInfoRow(
                                            label: item.itemName ?? '',
                                            value:
                                                item.quantity.toString() ?? '',
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween),
                                        if (index <
                                            supply.detailItems!.length - 1)
                                          Divider(
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                      ],
                                    ),
                                  );
                                }).toList() ??
                                [],
                            SizedBox(height: AppSizes.paddingMedium),
                            DashedLine(
                              height: _dashHeight,
                              color: AppColors.black,
                              dashWidth: _dashWidth,
                              dashSpace: _dashSpace,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList() ??
                  [],
              _buildFlightInfoRow(
                  label: 'Tổng',
                  value: '400',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: 'Quét mã để xem chi tiết phiếu cung ứng',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      color: AppColors.black,
                    ),
                    QrImageView(
                      data: 'https://baomoi.com/',
                      version: QrVersions.auto,
                      size: 160.w,
                    ),
                  ],
                ),
              ),
              CustomButton(
                horizontalPadding: AppSizes.paddingLarge,
                width: MediaQuery.of(context).size.width * 0.4,
                text: 'In phiếu',
                color: AppColors.primary,
                onPressed: handlePrint,
              ),
              SizedBox(height: AppSizes.paddingSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightInfoRow(
      {required String label,
      required String value,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.paddingXSmall),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          TextWidget(
            text: "${label}: ",
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          TextWidget(
            text: value,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
