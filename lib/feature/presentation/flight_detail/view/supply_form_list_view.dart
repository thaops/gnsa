import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/popup_information_sign.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_ag.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SupplyFormListView extends HookConsumerWidget {
  final List<SupplyFormDetail>? supplyForms;
  final bool isAdditional;
  final WidgetRef ref;
  final String? kValueSign;
  final String flightId;
  final bool isSupplement;

  const SupplyFormListView({
    required this.supplyForms,
    required this.isAdditional,
    required this.ref,
    this.kValueSign,
    required this.flightId,
    required this.isSupplement,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplyFormData = ref
        .watch(flightDetailProviderProvider(flightId, isSkipLoading: true))
        .when(
          data: (data) {
            return isAdditional
                ? data.additionalFormDetails
                : data.supplyFormDetails;
          },
          loading: () => supplyForms ?? [],
          error: (_, __) => supplyForms ?? [],
        );

    if (supplyFormData?.isEmpty ?? true) {
      return Center(
          child: Text(isAdditional
              ? 'Không có phiếu bổ sung'
              : 'Không có phiếu cung ứng'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: supplyFormData?.length ?? 0,
      itemBuilder: (context, index) => _buildSupplyItem(
        context,
        supplyFormData![index],
        supplyFormData[index].detailItems?.isEmpty ?? false,
        ref,
        flightId,
        isAdditional,
        index,
        isSupplement,
        kValueSign,
      ),
    );
  }
}

Widget _buildSupplyItem(
  BuildContext context,
  SupplyFormDetail supplyForm,
  bool isCheckSigned,
  // bool isExpanded,
  WidgetRef ref,
  String flightId,
  bool isAdditional,
  int index,
  bool isSupplement,
  String? kValueSign,
) {
  final currentData = ref.watch(flightDetailProviderProvider(flightId));
  
  // Lấy data mới nhất từ provider thay vì dùng parameter cũ
  final freshSupplyForm = currentData.when(
    data: (data) {
      final items = isAdditional ? data.additionalFormDetails : data.supplyFormDetails;
      return items?.firstWhere(
        (item) => item.supplyFormDetailId == supplyForm.supplyFormDetailId,
        orElse: () => supplyForm,
      ) ?? supplyForm;
    },
    loading: () => supplyForm,
    error: (_, __) => supplyForm,
  );

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.paddingMedium.h),
      child: CupertinoContextMenu(
        actions: [
          CupertinoContextMenuAction(
            onPressed: () async {
              if (isCheckSigned) {
                await CustomFlushbar.showError(context,
                    message: 'Chưa có phiếu để ký xác nhận');
                return;
              }
              context
                  .push(
                AppRouter.flightSignature,
                extra: FlightSignatureAg(
                    supplyformdetailId: [supplyForm.supplyFormDetailId],
                    isSupplement: isSupplement,
                    isSignAll: false),
              )
                  .then((value) async {
                if (value == true) {
                  try {
                    await ref
                        .refresh(flightDetailProviderProvider(flightId).future);
                  } catch (e) {
                    ref.invalidate(flightDetailProviderProvider(flightId));
                  }
                }
              });
            },
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
            title: '${freshSupplyForm.supplyType} - ${freshSupplyForm.supplyName}',
            subtitle: 'Mã code: ${freshSupplyForm.supplyCode}',
            leadingIcon: Icons.airplane_ticket,
            supplyType: freshSupplyForm.supplyType,
            trailingCount: '${freshSupplyForm.supplyType}',
            isAdditional: isAdditional,

            // status: supplyForm.status,
            isNotSigned: freshSupplyForm.status == kValueSign,
            supplyFormDetailId: freshSupplyForm.supplyFormDetailId,
            detailItems: freshSupplyForm.detailItems,
            onConfirm: () => showDialog(
              context: context,
              builder: (context) => PopupInformationSign(
                supplyfromId: freshSupplyForm.supplyFormDetailId,
              ),
            ),
          ),
        ),
      ),
    );
}
