import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_select_search.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_add_req_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/card_list_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/providers.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/appbar_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopupCreateFood extends HookConsumerWidget {
  final String supplyFormDetailId;
  const PopupCreateFood({super.key, required this.supplyFormDetailId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncListCard = ref.watch(cardListProviderProvider);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: asyncListCard.when(
          data: (data) => _buildata(data.map((e) => Item(id: e.id, name: e.name)).toList(), ref , context),
          loading: () => SizedBox(height: 200.h, child: const Center(child: CircularProgressIndicator())),
          error: (error, stack) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }

  Column _buildata(List<Item> data , WidgetRef ref , BuildContext context) {
    final controller = useTextEditingController();
    final selectItem = useState<String?>(null);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppbarDialog(
          title: 'Thêm xe đẩy',
        ),
        SizedBox(height: AppSizes.spacingSmall.h),
        CustomSelectSearch(
          label1: 'Loại xe đẩy',
          selectList: data,
          onProjectSelected: (value) {
            selectItem.value = value;
          },
        ),
        TextWidget(
          text: 'Số lượng',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller,
          hintText: "0",
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        CustomButton(
          text: 'Xác nhận',
          color: AppColors.primary,
          borderRadius: AppSizes.radiusMedium,
          onPressed: () {
            if (selectItem.value == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vui lòng chọn loại xe đẩy')),
              );
              return;
            }
            if (controller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Vui lòng nhập số lượng')),
              );
              return;
            }
            ref.read(flightDetailUserCaseProvider).addCardItem(CardAddReqModel(
              cartId: selectItem.value!,
              quantity: int.parse(controller.text),
              supplyFormDetailId: supplyFormDetailId,
            )).then((value) {
              if (value) {
              ref.read(flightDetailProviderProvider(ref.read(flightId),isSkipLoading: true).notifier).fetchFlightDetail(ref.read(flightId),isSkipLoading: true);
                GoRouter.of(context).pop();
              }
            });
          },
        )
      ],
    );
  }
}
