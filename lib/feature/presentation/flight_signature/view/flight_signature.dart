import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_arguments.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
import 'package:gnsa/feature/presentation/flight_signature/provider/flight_signature_provider.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Constants
const _kSpacing = 6.0;
const _idNotData = '00000000-0000-0000-0000-000000000000';

class FlightSignature extends HookConsumerWidget {
  final bool isSupplement;
  final List<String> supplyfromdetailId;

  const FlightSignature(
      {super.key,
      required this.supplyfromdetailId,
      required this.isSupplement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("arguments: ${supplyfromdetailId.first}");

    final flightSignatureAsync =
        ref.watch(flightSignatureControllerProvider(supplyfromdetailId.first));
    final flightSignState = ref.read(
        flightSignatureControllerProvider(supplyfromdetailId.first).notifier);

    // useEffect(() {
    //   Future.microtask(
    //       () => flightSignState.getSingSupplyfrom(supplyfromId.first));
    //   return null;
    // }, [supplyfromId]);

    return Scaffold(
      appBar: const AppBarWidget(title: 'Xác nhận'),
      body: flightSignatureAsync.when(
        data: (data) => SignatureContent(
          supplyfromId: supplyfromdetailId,
          signDetail: data,
          onRefresh: () =>
              flightSignState.getSingSupplyfrom(supplyfromdetailId.first),
          isSupplement: isSupplement,
        ),
        error: (err, _) => SignatureContent(
          supplyfromId: supplyfromdetailId,
          signDetail: SignSupplyfrom(),
          onRefresh: () =>
              flightSignState.getSingSupplyfrom(supplyfromdetailId.first),
          isSupplement: isSupplement,
        ),
        loading: () => _buildLoading(context),
      ),
    );
  }

  LoadingShimmer _buildLoading(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return LoadingShimmer(
        child: Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              paddingHorizontal: 16,
              text: 'TIẾP VIÊN XÁC NHẬN',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: _kSpacing.h),
            Expanded(
              child: ContainerLoading(
                height: height * 0.26,
              ),
            ),
            SizedBox(height: AppSizes.spacingLarge.h),
            const TextWidget(
              paddingHorizontal: 16,
              text: 'NHÂN VIÊN XÁC NHẬN',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: _kSpacing.h),
            Expanded(
              child: ContainerLoading(
                height: height * 0.26,
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class SignatureContent extends StatelessWidget {
  final List<String> supplyfromId;
  final SignSupplyfrom signDetail;
  final VoidCallback onRefresh;
  final bool isSupplement;

  const SignatureContent({
    super.key,
    required this.supplyfromId,
    required this.signDetail,
    required this.onRefresh,
    required this.isSupplement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium.r),
      child: Column(
        spacing: AppSizes.spacingMedium.h,
        children: [
          Expanded(
            child: CustomSignature(
                crewInfo: signDetail.crew,
                isCrew: true,
                onPressed: () {
                  GoRouter.of(context)
                      .push(
                    AppRouter.flightSign,
                    extra: FlightSignArguments(
                      title: 'TIẾP VIÊN XÁC NHẬN',
                      supplyFormIds: supplyfromId,
                      isSupplierSign: true,
                      isSupplement: isSupplement,
                    ),
                  )
                      .then((value) {
                    if (value == true) {
                      Future.microtask(onRefresh);
                    }
                  });
                }),
          ),
          Expanded(
            child: CustomSignature(
                crewInfo: signDetail.employee,
                isCrew: false,
                onPressed: () {
                  GoRouter.of(context)
                      .push(
                    AppRouter.flightSign,
                    extra: FlightSignArguments(
                      title: 'NHÂN VIÊN XÁC NHẬN',
                      supplyFormIds: supplyfromId,
                      isSupplierSign: false,
                      isSupplement: isSupplement,
                    ),
                  )
                      .then((value) {
                    if (value == true) {
                      Future.microtask(onRefresh);
                    }
                  });
                }),
          ),
          signDetail.employee?.id != _idNotData &&
                  signDetail.crew?.id != _idNotData
              ? _buildComfirm(context)
              : const SizedBox(),
        ],
      ),
    );
  }

  Column _buildComfirm(BuildContext context) {
    return Column(
      spacing: AppSizes.spacingSmall,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: 'Tổng số vật tư',
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
              color: AppColors.black,
            ),
            TextWidget(
              text: signDetail.totalSupply.toString(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
        CustomButton(
          horizontalPadding: AppSizes.paddingMedium.r,
          onPressed: () {
            GoRouter.of(context).pop(true);
          },
          color: AppColors.primary,
          text: 'Xác nhận',
        ),
        SizedBox(height: AppSizes.spacingMedium.h),
      ],
    );
  }
}
