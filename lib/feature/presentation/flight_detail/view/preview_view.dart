import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/method_channel/printer_plugin.dart';
import 'package:gnsa/common/utils/dash_line.dart';
import 'package:gnsa/common/utils/date_utils.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
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
  PreviewView({super.key, required this.args});

  final UrovoPrinter _printer = UrovoPrinter();

  Future<Uint8List?> generateQrBytes(String data, {double size = 200}) async {
    try {
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: false,
      );
      final picData = await qrPainter.toImageData(size);
      return picData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  Future<void> handlePrint(
      BuildContext context, FlightPreviewModel data) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final qrBytes = await generateQrBytes(
          data.linkUrl ?? data.flightInfo?.flightNo ?? "");

      final Map<String, dynamic> printData = {
        'FlightInfo': data.flightInfo?.toJson(),
        'SupplyFormDetails':
            data.supplyFormDetails?.map((detail) => detail.toJson()).toList() ??
                [],
        'TotalSupply': data.totalSupply,
        'LinkUrl': data.linkUrl,
        'QRCode': qrBytes,
        'SupplyFormCode': data.supplyFormCode,

      };

      final result = await _printer.printPreview(printData);

      Navigator.of(context).pop();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to print. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
              _buildHeaderPreview(data.supplyFormCode.toString() ?? ''),
              Container(
                color: AppColors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              _buildFlightInfoRow(
                                  label: 'Flight',
                                  value: data.flightInfo?.routing ?? ''),
                              _buildFlightInfoRow(
                                  label: 'Flight No',
                                  value: data.flightInfo?.flightNo ?? ''),
                            ])),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              _buildFlightInfoRow(
                                  label: 'PK',
                                  value: data.flightInfo?.pk ?? ''),
                              _buildFlightInfoRow(
                                  label: 'A/C',
                                  value: data.flightInfo?.acfNo ?? ''),
                            ]))
                      ],
                    ),
                    _buildFlightInfoRow(
                        label: 'Flight', value: data.flightInfo?.routing ?? ''),
                    _buildFlightInfoRow(
                        label: 'Flight No',
                        value: data.flightInfo?.flightNo ?? ''),
                    _buildFlightInfoRow(
                        label: 'Arrival',
                        value: DateUtilsCustom.formatStringDateTime(
                            data.flightInfo?.arrivalDate ?? '')),
                    _buildFlightInfoRow(
                        label: 'Departure',
                        value: DateUtilsCustom.formatStringDateTime(
                            data.flightInfo?.departureDate ?? '')),
                    _buildFlightInfoRow(
                        label: 'Departure By',
                        value:
                            "${data.flightInfo?.deliveryCode} ${data.flightInfo?.deliveryBy}"),
                    _buildFlightInfoRow(
                        label: 'Departure Date',
                        value: DateUtilsCustom.formatStringDateTime(
                            data.flightInfo?.deliveryDate ?? '')),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.paddingXSmall),
              _buildFlightInfoRow(
                  label: 'Name',
                  value: 'Qty',
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
                              isSupply: true,
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
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
                  label: 'Total',
                  value: data.totalSupply.toString() ?? '',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: AppSizes.spacingXSmall,
                  children: [
                    TextWidget(
                      text: 'Scan the QR code to view supply details',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      color: AppColors.black,
                    ),
                    QrImageView(
                      data: data.linkUrl ?? '',
                      version: QrVersions.auto,
                      size: 160.w,
                    ),
                    TextWidget(
                      text: 'Signed/Confirmed before printing',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.paddingSmall),
              CustomButton(
                horizontalPadding: AppSizes.paddingLarge,
                width: MediaQuery.of(context).size.width * 0.4,
                text: 'In phiếu',
                color: AppColors.primary,
                onPressed: () => handlePrint(context, data),
              ),
              SizedBox(height: AppSizes.paddingSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderPreview(String code) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSizes.paddingSmall,
        children: [
          Image.asset(
            Img.logo,
            fit: BoxFit.cover,
          ),
          TextWidget(
            text: 'Vietnam Airlines Caterers',
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          TextWidget(
            text:
                'Tan Son Nhat International Airport, Tan Son Hoa Ward,\n Ho Chi Minh City, Vietnam.',
            textAlign: TextAlign.center,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            maxLines: 2,
          ),
          TextWidget(
            text: "(84 - 28) 38.448.367",
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          Divider(
            height: _heightDivider,
            color: AppColors.black,
          ),
          TextWidget(
            text: "Delivery and Receipt Note",
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
          TextWidget(
              text: "Code: ${code}",
              fontSize: 16.sp,
              fontWeight: FontWeight.w500),
          SizedBox(height: AppSizes.paddingSmall),
        ]);
  }

  Widget _buildFlightInfoRow({
    required String label,
    required String value,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    bool? isSupply = false,
  }) {
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
          isSupply == true
              ? TextWidget(
                  text: " (${value})",
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                )
              : TextWidget(
                  text: value,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
        ],
      ),
    );
  }
}
