import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/get_qr_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/ids_not_sign_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_loading_case.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/keep_alive_flight_detail_content.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

const _kValueSign = 'NotSigned';
const _paddingHorizontalMobile = 16.0;
const _paddingWebRatio = 0.3;
const _paddingTabletRatio = 0.1;

class FlightDetailScreen extends HookConsumerWidget {
  const FlightDetailScreen({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      print("idsss: $id");

      Future.microtask(() => ref.read(flightId.notifier).state = id);
      return null;
    }, [id]);

    final state = ref.watch(flightDetailProviderProvider(id));

    state.whenData((data) {
      Future.microtask(() {
        final idsNotSign = <String>[];
        final idsNotSignAdditional = <String>[];

        data.supplyFormDetails?.forEach((element) {
          if (element.status == _kValueSign &&
              element.detailItems?.isNotEmpty == true) {
            idsNotSign.add(element.supplyFormDetailId);
          }
        });

        data.additionalFormDetails?.forEach((element) {
          if (element.status == _kValueSign &&
              element.detailItems?.isNotEmpty == true) {
            idsNotSignAdditional.add(element.supplyFormDetailId);
          }
        });

        ref.read(idsNotSignProvider.notifier).setIds(idsNotSign);
        ref
            .read(idsNotSignAdditionalProvider.notifier)
            .setIds(idsNotSignAdditional);
      });
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context, ref, state, id),
      body: _buildBody(context, ref, state),
    );
  }

  void _showPrinterDialog(
      BuildContext context, WidgetRef ref, AsyncValue<SupplyFormModel> state) {
    state.when(
      data: (data) => showDialog(
        context: context,
        builder: (_) => FlightPrinter(flightDetailModel: data, flightId: id),
      ),
      loading: () => const SizedBox(),
      error: (error, stack) => StateErr(error: error.toString()),
    );
  }

  double _getHorizontalPadding(double width, BuildContext context) {
    if (ResponsiveHelper.isWeb(context)) return width * _paddingWebRatio;
    if (ResponsiveHelper.isTablet(context)) return width * _paddingTabletRatio;
    return _paddingHorizontalMobile;
  }

  AppBarWidget _buildAppBar(BuildContext context, WidgetRef ref,
      AsyncValue<SupplyFormModel> state, String flightId) {
    return AppBarWidget(
      title: 'Cung ứng vật tư',
      isBack: true,
      isTitleCenter: true,
      popupMenuItems: [
        PopupMenuItem<String>(
          value: 'preview',
          child: Row(
            children: [
              Icon(Icons.file_present_outlined,
                  color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
              TextWidget(
                text: 'Xem trước',
                fontSize: 14.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'qr',
          child: Row(
            children: [
              Icon(Icons.qr_code, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
              TextWidget(
                text: 'Mã QR',
                fontSize: 14.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'printer',
          child: Row(
            children: [
              Icon(Icons.print, color: AppColors.primary, size: 18.sp),
              SizedBox(width: 8.w),
              TextWidget(
                text: 'In',
                fontSize: 14.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
      onPopupMenuSelected: (value) async {
        switch (value) {
          case 'printer':
            _showPrinterDialog(context, ref, state);
            break;
          case 'qr':
            context.push(AppRouter.qrcode, extra: flightId);
            break;
          case 'preview':
            if (!context.mounted) return;

            try {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đang tải URL...')),
              );

              final qrAsyncValue =
                  ref.read(getQrProviderProvider(flightId).future);

              final url = await qrAsyncValue.timeout(Duration(seconds: 15));

              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }

              if (url.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Không nhận được URL từ máy chủ. Vui lòng thử lại sau.')),
                  );
                }
                return;
              }

              if (context.mounted) {
                openUrlSafe(url, context);
              }
            } on TimeoutException catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Hết thời gian chờ. Vui lòng kiểm tra kết nối mạng.')),
                );
              }
            } catch (err, stack) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Không mở được web: $err')),
                );
              }
            }
            break;
        }
      },
    );
  }

  Future<void> openUrlSafe(String link, BuildContext context) async {
    if (link.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Không nhận được URL từ máy chủ. Vui lòng thử lại sau.')),
        );
      }
      return;
    }

    final uri = Uri.parse(link);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Không mở được: $link')),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi mở link: $e')),
        );
      }
    }
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, AsyncValue<SupplyFormModel> state) {
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = _getHorizontalPadding(size.width, context);

    return state.when(
      data: (data) {
        if (data.supplyFormId == null &&
            data.supplyFormDetails?.isEmpty == true) {
          return const Center(child: Text('Không có chi tiết chuyến bay'));
        }
        return KeepAliveFlightDetailContent(
          data: data,
          horizontalPadding: horizontalPadding,
          ref: ref,
          flightId: id,
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: LoadingShimmer(
          child: CustomLoadingCase(),
        ),
      ),
      error: (error, stack) => StateErr(error: error.toString()),
    );
  }
}
