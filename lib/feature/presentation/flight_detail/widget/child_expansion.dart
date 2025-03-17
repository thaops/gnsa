import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';

class ChildExpansion extends HookWidget {
  final SupplyItem? supplyItem;

  const ChildExpansion({Key? key, this.supplyItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEdit = useState(false);
    final noteState = useState(supplyItem?.note ?? '');

    final noteController = useTextEditingController(
      text: supplyItem?.note ?? '',
    );
    void _saveNote() {
      supplyItem?.note = noteController.text; // Cập nhật model
      noteState.value = noteController.text; // Cập nhật trạng thái cục bộ
      isEdit.value = false; // Thoát chế độ chỉnh sửa
    }

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: supplyItem?.categoryName ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 6),
                  TextWidget(
                    text: supplyItem?.confirmedQuantity.toString() ?? '',
                    fontSize: 14,
                    color: AppColors.iconFlight,
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
              isEdit.value
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Xử lý hành động xóa (chưa triển khai)
                          },
                          icon: Icon(Icons.delete, color: AppColors.iconFlight),
                        ),
                        IconButton(
                          onPressed: () {
                            _saveNote();
                          },
                          icon: Icon(Icons.check, color: AppColors.iconFlight),
                        ),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        // Bật edit mode
                        isEdit.value = true;
                      },
                      icon: Icon(Icons.edit_note_sharp,
                          color: AppColors.iconFlight),
                    ),
            ],
          ),
          isEdit.value
              ? Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width,
                  child: CustomTextField(
                    borderColor: Colors.transparent,
                    backgroundColor: AppColors.backgroundTab,
                    hintText: 'Ghi chú',
                    controller: noteController,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
