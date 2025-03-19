import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/date_utils.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/appbar_dialog.dart';
import 'package:gnsa/feature/presentation/flight_signature/controller/flight_signature_controller.dart';
import 'package:gnsa/feature/presentation/flight_signature/model/sign_supplyfrom.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopupInformationSign extends HookConsumerWidget {
  final String supplyfromId;
  const PopupInformationSign({
    super.key,
    required this.supplyfromId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightSignState = ref.read(flightSignatureProvider.notifier);
    final flightSignAsync = ref.watch(flightSignatureProvider);
    useEffect(() {
      Future.microtask(() => flightSignState.getSingSupplyfrom(supplyfromId));
      return null;
    }, [supplyfromId]);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppbarDialog(
              title: 'Thông tin xác nhận',
            ),
            const SizedBox(height: 16),
            flightSignAsync.when(
                data: (data) => _buildPopup(data),
                error: (err, stackTrace) => Text(err.toString()),
                loading: () => _buildLoading())
          ],
        ),
      ),
    );
  }

  LoadingShimmer _buildLoading() {
    return LoadingShimmer(
        child: Column(
      children: [
        const ContainerLoading(
          height: 60,
        ),
        SizedBox(height: 16.h),
        const ContainerLoading(
          height: 60,
        )
      ],
    ));
  }

  Column _buildPopup(SignSupplyfrom data) {
    return Column(
      children: [
        _buildSignName(
            img: data.supplierSign.toString(),
            name: data.supplierName,
            isSupplier: true,
            date: DateUtilsCustom.formatStringDate(data.supplierSignDate)),
        SizedBox(height: 16.h),
        _buildSignName(
            img: data.receiveSign.toString(),
            name: data.receiveName,
            isSupplier: false,
            date: DateUtilsCustom.formatStringDate(data.receiverSignDate)),
      ],
    );
  }

  Container _buildSignName(
      {String? img, String? name, String? date, bool isSupplier = true}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildImage(img.toString()),
          _buildTextSign(name: name, date: date, isSupplier: isSupplier),
        ],
      ),
    );
  }

  Expanded _buildTextSign(
      {String? name, String? date, bool isSupplier = true}) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.r, vertical: 8.0.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: name.toString().trim(),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 4.h),
            TextWidget(
              text: '${isSupplier ? "Tiếp viên " : "Nhân viên"} - $date',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.black.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildImage(String img) {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 70.r,
        width: 130.r,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
          ),
          child: Image(
            image: NetworkImage(img),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
