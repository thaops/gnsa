import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/popup_information_sign.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplyFormListView extends StatefulWidget {
  final List<SupplyFormDetail>? supplyForms;
  final bool isAdditional;
  // final bool isExpanded;
  final WidgetRef ref;
  final String? kValueSign;

  const SupplyFormListView({
    required this.supplyForms,
    required this.isAdditional,
    // required this.isExpanded,
    required this.ref,
    this.kValueSign,
    super.key,
  });

  @override
  State<SupplyFormListView> createState() => _SupplyFormListViewState();
}



class _SupplyFormListViewState extends State<SupplyFormListView> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(widget.supplyForms?.isEmpty == true) return Center(child: Text(widget.isAdditional ? 'Không có phiếu bổ sung' : 'Không có phiếu cung ứng'));
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.supplyForms?.length ?? 0,
      itemBuilder: (context, index) => _buildSupplyItem(
        context,
        widget.supplyForms![index],
        // isExpanded,
        widget.ref,
        widget.isAdditional,
        widget.kValueSign,
      ),
    );
  }
}

Widget _buildSupplyItem(
    BuildContext context,
    SupplyFormDetail supplyForm,
    // bool isExpanded,
    WidgetRef ref,
    bool isAdditional,
    String? kValueSign,
  ) =>
      Padding(
        padding: EdgeInsets.only(bottom: AppSizes.paddingMedium.h),
        child: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              onPressed: () => context.push(
                AppRouter.flightSignature,
                extra: [supplyForm.supplyFormDetailId],
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
              title: '${supplyForm.supplyType} - ${supplyForm.supplyName}',
              subtitle: 'Mã code: ${supplyForm.supplyCode}',
              leadingIcon: Icons.airplane_ticket,
              supplyType: supplyForm.supplyType,
              trailingCount: '${supplyForm.supplyType}',
              isAdditional: isAdditional,
              isNotSigned: supplyForm.status == kValueSign,
              supplyFormDetailId: supplyForm.supplyFormDetailId,
              detailItems: supplyForm.detailItems,
              onConfirm: () => showDialog(
                context: context,
                builder: (context) => PopupInformationSign(
                  supplyfromId: supplyForm.supplyFormDetailId,
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