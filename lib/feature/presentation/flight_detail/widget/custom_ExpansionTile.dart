import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/filght_bool_state.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/child_expansion.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomExpansionTile extends HookConsumerWidget {
  final Color? backgroundColor;
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final String trailingCount;
  final bool isConfirmed;
  final bool isExpanded;
  final SupplyForm? supplyForm;
  final VoidCallback? onTap;
  final VoidCallback onConfirm;

  const CustomExpansionTile({
    Key? key,
    this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.trailingCount,
    required this.isConfirmed,
    required this.isExpanded,
    this.supplyForm,
    this.onTap,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpandedHook = useState<bool>(isExpanded);

    final isAllExpanded = ref.watch(isChildExpandedProvider);
    useEffect(() {
      isExpandedHook.value = isAllExpanded;
      return null;
    }, [isAllExpanded]);
    return InkWell(
      onTap: onTap,
      child: Container(
        key: ValueKey(isAllExpanded),
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.backgroundTab,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpandedHook.value,
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Icon(leadingIcon, color: AppColors.iconFlight),
          title: TextWidget(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          subtitle: TextWidget(
            text: subtitle,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidget(
                text: trailingCount,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              isConfirmed ? _ComfimerWidget() : const SizedBox(),
            ],
          ),
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: supplyForm?.supplies?.length ?? 0,
              itemBuilder: (context, outerIndex) => ExpansionTile(
                initiallyExpanded: isExpandedHook.value,
                backgroundColor: AppColors.backgroundTab,
                iconColor: AppColors.primary,
                title: TextWidget(
                  text: supplyForm?.supplies?[outerIndex].categoryName.toString() ??'',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        supplyForm?.supplies?[outerIndex].items?.length ?? 0,
                    itemBuilder: (context, innerIndex) => ChildExpansion(
                      index: (innerIndex + 1).toString(),
                      supplyItem:
                          supplyForm?.supplies?[outerIndex].items?[innerIndex],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ComfimerWidget() {
    return InkWell(
      onTap: () => {
        onConfirm.call()
      },
      child: Column(
        children: [
          Container(
            height: 20.h,
            width: 70.h,
            padding:  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.textSuccess,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: AppColors.white, size: 8.w),
                SizedBox(width: 3.w),
              const  TextWidget(
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
    );
  }
}
