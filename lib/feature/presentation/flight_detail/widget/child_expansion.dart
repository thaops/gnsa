// child_expansion.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/filght_bool_state.dart' show isEditProvider;

class ChildExpansion extends ConsumerWidget {
  const ChildExpansion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final isEdit = ref.watch(isEditProvider);
   final flightBoolNotifier = ref.read(isEditProvider.notifier);

   final noteController = TextEditingController();

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
                  const TextWidget(
                    text: 'Nước tinh khiết Aquafina 1,5L',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 6),
                  TextWidget(
                    text: 'Cung ứng: 10',
                    fontSize: 14,
                    color: AppColors.iconFlight,
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
              isEdit
                  ? Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            flightBoolNotifier.toggleEdit();
                          },
                          icon:  Icon(Icons.delete, color: AppColors.iconFlight),
                        ),
                         Icon(Icons.check, color: AppColors.iconFlight),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        flightBoolNotifier.toggleEdit();
                      },
                      icon:  Icon(Icons.edit_note_sharp, color: AppColors.iconFlight),
                    ),
            ],
          ),
          isEdit
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
