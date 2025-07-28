import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeView extends StatelessWidget {
  const QrcodeView({super.key});

  @override
  Widget build(BuildContext context) {
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
          QrImageView(
            data: 'https://baomoi.com/',
            version: QrVersions.auto,
            size: 320.w,
          ),
        ],
      ),
    );
  }
}
