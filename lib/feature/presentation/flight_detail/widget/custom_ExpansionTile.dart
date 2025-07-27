import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/enum_type_flight.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/poup_create_food.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/child_expansion.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomExpansionTile extends HookConsumerWidget {
  final Color? backgroundColor;
  final String title;
  final String subtitle;
  final String supplyType;
  final IconData leadingIcon;
  final bool isAdditional;
  final String trailingCount;
  final bool isConfirmed;
  // final bool isExpanded;
  final String supplyFormDetailId;
  final List<DetailItemGroup>? detailItems;
  // final VoidCallback? onTap;
  final VoidCallback onConfirm;

  const CustomExpansionTile({
    Key? key,
    this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.supplyType,
    required this.leadingIcon,
    required this.isAdditional,
    required this.trailingCount,
    required this.isConfirmed,
    // required this.isExpanded,
    required this.supplyFormDetailId,
    this.detailItems,
    // this.onTap,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  final isExpandedHook = useState<bool>(isExpanded);

    //   final isAllExpanded = ref.watch(isChildExpandedProviderProvider);
    // useEffect(() {
    //  // isExpandedHook.value = isAllExpanded;
    //   return null;
    // }, [isAllExpanded]);
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.backgroundTab,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: ExpansionTile(
          // initiallyExpanded: false,
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Icon(leadingIcon, color: AppColors.iconFlight),
          title: TextWidget(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          subtitle: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextWidget(
                  text: subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              isConfirmed ? _comfimerWidget() : const SizedBox(),
            ],
          ),
          // trailing: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     TextWidget(
          //       text: trailingCount,
          //       fontSize: 12,
          //       fontWeight: FontWeight.w500,
          //     ),
          //     isConfirmed ? _ComfimerWidget() : const SizedBox(),
          //   ],
          // ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: detailItems?.length ?? 0,
              itemBuilder: (context, outerIndex) => ExpansionTile(
                // initiallyExpanded: isExpandedHook.value,
                backgroundColor: AppColors.backgroundTab,
                iconColor: AppColors.primary,
                title: TextWidget(
                  text: detailItems?[outerIndex].className.toString() ?? '',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: detailItems![outerIndex].items.length,
                    itemBuilder: (context, groupIndex) => Column(
                      children: detailItems![outerIndex]
                          .items[groupIndex]
                          .supplyItems
                          .asMap()
                          .entries
                          .map((entry) {
                        final supplyItem = entry.value;
                        return ChildExpansion(
                          supplyItem: supplyItem,
                          supplyType: supplyType,
                          detailItemId: detailItems![outerIndex].items[groupIndex].itemId,
                          supplyFormDetailId: supplyFormDetailId,
                          isAdditional: isAdditional,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.spacingSmall),
            if (containsAnySupplyFormType(title) && isAdditional) _addCart(context)
          ],
        ),
      ),
    );
  }

  InkWell _addCart(BuildContext context) {
    return InkWell(
      onTap: () => {
        showDialog(context: context, builder: (context) => PopupCreateFood()),
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingMedium,
            vertical: AppSizes.paddingXXSmall),
        decoration: BoxDecoration(
          color: AppColors.backgroundTab,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.primary, width: 0.5.w),
        ),
        child: Center(
          child: TextWidget(
            text: "+ Thêm xe đẩy",
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _comfimerWidget() {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () => {onConfirm.call()},
        child: Column(
          children: [
            Container(
              height: 20.h,
              width: 80.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.textSuccess,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: AppColors.white, size: 8.w),
                  SizedBox(width: 3.w),
                  const TextWidget(
                    text: "Đã Xác nhận",
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
