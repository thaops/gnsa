import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/get_qr_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeView extends HookConsumerWidget {
  final String flightId;
  const QrcodeView({super.key, required this.flightId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrProvider = ref.watch(getQrProviderProvider(flightId));
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Quét QR',
      ),
      body: Column(
        children: [
          SizedBox(height: AppSizes.paddingLarge.h),
          Image.asset(Img.logo),
          SizedBox(height: AppSizes.paddingXXXXLarge.h),
          TextWidget(
            paddingHorizontal: 36.w,
            text: 'Quét mã để xem chi tiết phiếu cung ứng',
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
            textAlign: TextAlign.center,
            maxLines: 2,
            color: AppColors.black,
          ),
          // CachedNetworkImage(
          //   imageUrl:
          //       'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/800px-QR_code_for_mobile_English_Wikipedia.svg.png',
          //   width: 329.w,
          //   height: 320.h,
          //   placeholder: (context, url) => const CircularProgressIndicator(),
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          // ),
          qrProvider.when(
            data: (data) => QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 320.w,
            ),
            error: (error, stackTrace) => const Icon(Icons.error),
            loading: () => const LoadingShimmer(
              child: ContainerLoading(
                height: 320,
                width: 320,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
