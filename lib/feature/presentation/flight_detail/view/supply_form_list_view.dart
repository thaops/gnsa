import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/filght_bool_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/popup_information_sign.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplyFormListView extends StatelessWidget {
  final List<SupplyForm>? supplyForms;
  final bool isExpanded;
  final WidgetRef ref;
  final String? kValueSign;

  const SupplyFormListView({
    required this.supplyForms,
    required this.isExpanded,
    required this.ref,
    this.kValueSign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final flightDetailAsync = ref.watch(flightDetailProviderProvider);

    return flightDetailAsync.when(
      error: (error, _) => StateErr(error: error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (data) => ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: supplyForms?.length ?? 0,
      itemBuilder: (context, index) => _buildSupplyItem(
        context,
        supplyForms![index],
        isExpanded,
        ref,
        kValueSign,
      ),
    ),
    );
  }
}

Widget _buildSupplyItem(
    BuildContext context,
    SupplyForm supplyForm,
    bool isExpanded,
    WidgetRef ref,
    String? kValueSign,
  ) =>
      Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingMedium.h),
        child: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              onPressed: () => context.push(
                AppRouter.flightSignature,
                extra: [supplyForm.supplyFormId!],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit, color: AppColors.primary),
                  SizedBox(width: 10.w),
                  const TextWidget(
                    text: 'Ký xác nhận',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
          child: Material(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge.r),
            color: AppColors.backgroundTab,
            child: CustomExpansionTile(
              backgroundColor: AppColors.backgroundTab,
              title: '${supplyForm.category} - ${supplyForm.className}',
              subtitle: 'Mã code: ${supplyForm.supplyFormCode}',
              leadingIcon: Icons.airplane_ticket,
              trailingCount: '${supplyForm.totalSupply}',
              isConfirmed: supplyForm.status != kValueSign,
              isExpanded: isExpanded,
              onTap: () => ref.read(isChildExpandedProviderProvider.notifier).toggle(),
              supplyForm: supplyForm,
              onConfirm: () => showDialog(
                context: context,
                builder: (context) => PopupInformationSign(
                  supplyfromId: supplyForm.supplyFormId!,
                ),
              ),
            ),
          ),
        ),
      );

  // LoadingShimmer _buildLoading(double horizontalPadding) => LoadingShimmer(
  //       child: _bodyState(
  //         horizontalPadding,
  //         SizedBox(
  //           height: 200.h,
  //           child: const Column(
  //             children: [
  //               ChildLoadingList(child: ContainerLoading()),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );

  // Widget _bodyState(double horizontalPadding, Widget child) => Center(
  //       child: SingleChildScrollView(
  //         padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppSizes.paddingMedium.h),
  //         child: child,
  //       ),
  //     );