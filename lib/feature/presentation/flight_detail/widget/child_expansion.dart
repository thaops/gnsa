import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/enum_type_flight.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/providers.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/supply_from_update_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class ChildExpansion extends HookConsumerWidget {
  final SupplyItem? supplyItem;
  final String supplyType;
  final String supplyFormDetailId;
  final String detailItemId;
  final bool isAdditional;

  const ChildExpansion(
      {Key? key,
      this.supplyItem,
      required this.supplyType,
      required this.supplyFormDetailId,
      required this.detailItemId,
      required this.isAdditional})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SupplyFromUpdateProvider =
        ref.watch(supplyFromUpdateProviderProvider.notifier);
    final isEdit = useState(false);
    final noteState = useState(supplyItem?.note ?? '');
    final focusNode = useFocusNode();

    final confirmedQuantity = useState<int>(supplyItem?.additionalQuantity ?? 0);

    final noteController = useTextEditingController(
      text: supplyItem?.note ?? '',
    );
    final parsedSupplyType = SupplyFormTypeExtension.fromString(supplyType);
    void _saveNote() {
      focusNode.unfocus();
      noteState.value = noteController.text;
      isEdit.value = false;
      SupplyFromUpdateProvider.updateSupplyfromItemDetail(
          UpdateSupplyfromItemReq(
        supplyFormDetailId: supplyFormDetailId,
        supplyFormDetailItemId: detailItemId,
        itemId: supplyItem!.id,
        type: supplyType,
        supplement: confirmedQuantity.value,
        note: noteController.text,
      )).then((value) {
        ref.read(flightDetailProviderProvider(ref.read(flightId),isSkipLoading: true).notifier).fetchFlightDetail(ref.read(flightId),isSkipLoading: true);
      });
    }

    void _incrementQuantity() {
      confirmedQuantity.value++;
    }

    void _decrementQuantity() {
      if (confirmedQuantity.value > 0) {
        confirmedQuantity.value--;
      }
    }

    void _closeEdit() {
      focusNode.unfocus();
      noteController.text = noteState.value;
      confirmedQuantity.value = supplyItem?.additionalQuantity ?? 0;
      isEdit.value = false;
    }

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: "${supplyItem?.name ?? ''}",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              parsedSupplyType?.isEditable == true ? 
              isEdit.value
                  ? _buildWidgetAction(_saveNote, _closeEdit)
                  : IconButton(
                      onPressed: () {
                        isEdit.value = true;
                      },
                      icon: const Icon(Icons.edit_note_sharp,
                          color: AppColors.darkBackground),
                    ) : const SizedBox(),
            ],
          ),
          _buildSupplyQuantityRow(
              isEdit: isEdit,
              decrementQuantity: _decrementQuantity,
              confirmedQuantity: confirmedQuantity,
              incrementQuantity: _incrementQuantity),
          isEdit.value
              ? _buildNote(context, noteController, focusNode)
              : const SizedBox(),
        ],
      ),
    );
  }

  Row _buildSupplyQuantityRow(
      {required ValueNotifier<bool> isEdit,
      required void Function() decrementQuantity,
      required ValueNotifier<int> confirmedQuantity,
      required void Function() incrementQuantity}) {
    return Row(
      children: [
        SizedBox(width: 8.w),
        TextWidget(
          text: "Cung ứng:  ${supplyItem?.supplyQuantity.toString() ?? ''}",
          fontSize: 12,
          color: AppColors.iconFlight,
          fontWeight: FontWeight.w300,
        ),
        SizedBox(width: 8.w),
        !isEdit.value && isAdditional
            ? TextWidget(
                text:
                    "Bổ sung:  ${supplyItem?.additionalQuantity.toString() ?? ''}",
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w300,
              )
            : const SizedBox(),
        const Spacer(),
        isEdit.value
            ? _buildQuantity(
                decrementQuantity: decrementQuantity,
                confirmedQuantity: confirmedQuantity,
                incrementQuantity: incrementQuantity)
            : const SizedBox(),
      ],
    );
  }

  Container _buildNote(BuildContext context,
      TextEditingController noteController, FocusNode focusNode) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      width: MediaQuery.of(context).size.width,
      child: CustomTextField(
        borderColor: Colors.transparent,
        backgroundColor: AppColors.backgroundTab,
        focusNode: focusNode,
        hintText: 'Ghi chú',
        controller: noteController,
      ),
    );
  }

  Row _buildQuantity(
      {required void Function() decrementQuantity,
      required ValueNotifier<int> confirmedQuantity,
      required void Function() incrementQuantity}) {
    return Row(
      spacing: AppSizes.spacingSmall,
      children: [
        InkWell(
          onTap: () {
            decrementQuantity();
          },
          child: SizedBox(
            width: 32.w,
            height: 32.h,
            child: const Icon(Icons.remove, color: AppColors.primary)),
        ),
        TextWidget(
          text: confirmedQuantity.value.toString(),
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w300,
        ),
        InkWell(
          onTap: () {
            incrementQuantity();
          },
          child: SizedBox(
            width: 32.w,
            height: 32.h,
            child: const Icon(Icons.add, color: AppColors.primary)),
        ),
      ],
    );
  }

  Row _buildWidgetAction(void Function() saveNote, void Function() closeEdit) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            closeEdit();
          },
          icon: Icon(Icons.close, color: AppColors.iconFlight),
        ),
        IconButton(
          onPressed: () {
            saveNote();
          },
          icon: Icon(Icons.check, color: AppColors.textSuccess),
        ),
      ],
    );
  }
}
