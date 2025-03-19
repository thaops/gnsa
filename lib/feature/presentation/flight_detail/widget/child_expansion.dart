import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/filght_supplyfrom_state.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChildExpansion extends HookConsumerWidget {
  final SupplyItem? supplyItem;
  final String index;

  const ChildExpansion({Key? key, this.supplyItem, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = useState(false);
    final noteState = useState(supplyItem?.note ?? '');
    final focusNode = useFocusNode();

    final quantity = useState<int>(supplyItem?.confirmedQuantity ?? 0);

    final noteController = useTextEditingController(
      text: supplyItem?.note ?? '',
    );
    void _saveNote() {
      focusNode.unfocus();
      supplyItem?.note = noteController.text;
      noteState.value = noteController.text;
      supplyItem!.confirmedQuantity = quantity.value;
      isEdit.value = false;
      ref.read(flightSupplyFormProvider).updateSupplyNote(
            SupplyFormId: supplyItem?.supplyFormId,
            SupplyId: supplyItem?.supplyId,
            ConfirmedQuantity: quantity.value,
            note: noteController.text,
          );
    }

    void _incrementQuantity() {
      quantity.value++;
    }

    void _decrementQuantity() {
      if (quantity.value > 0) {
        quantity.value--;
      }
    }

    void _closeEdit() {
      focusNode.unfocus();
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
                      text: "$index. ${supplyItem?.categoryName ?? ''}",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              isEdit.value
                  ? _buildWidgetAction(_saveNote, _closeEdit)
                  : IconButton(
                      onPressed: () {
                        isEdit.value = true;
                      },
                      icon:const Icon(Icons.edit_note_sharp,
                          color: AppColors.darkBackground),
                    ),
            ],
          ),
          _buildSupplyQuantityRow(isEdit, _decrementQuantity, quantity, _incrementQuantity),
          isEdit.value ? _buildNote(context, noteController, focusNode) : const SizedBox(),
        ],
      ),
    );
  }

  Row _buildSupplyQuantityRow(ValueNotifier<bool> isEdit, void Function() _decrementQuantity, ValueNotifier<int> quantity, void Function() _incrementQuantity) {
    return Row(
          children: [
            SizedBox(width: 8.w),
            TextWidget(
              text:
                  "Cung ứng:  ${supplyItem?.confirmedQuantity.toString() ?? ''}",
              fontSize: 12,
              color: AppColors.iconFlight,
              fontWeight: FontWeight.w300,
            ),
            const Spacer(),

            isEdit.value
                ? _buildQuantity(
                    _decrementQuantity, quantity, _incrementQuantity)
                : const SizedBox(),
          ],
        );
  }

  Container _buildNote(
      BuildContext context, TextEditingController noteController, FocusNode focusNode) {
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

  Row _buildQuantity(void Function() decrementQuantity,
      ValueNotifier<int> quantity, void Function() incrementQuantity) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            decrementQuantity();
          },
          icon: const Icon(Icons.remove, color: AppColors.primary),
        ),
        TextWidget(
          text: quantity.value.toString(),
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w300,
        ),
        IconButton(
          onPressed: () {
            incrementQuantity();
          },
          icon: const Icon(Icons.add, color: AppColors.primary),
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
