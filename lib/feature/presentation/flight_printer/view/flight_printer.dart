import 'package:flutter/material.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/appbar_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/constom_checkbox.dart';
import 'package:gnsa/feature/presentation/flight_printer/controller/flight_printer_controller.dart';

class FlightPrinter extends HookConsumerWidget {
  final FlightDetailModel flightDetailModel;

  const FlightPrinter({super.key, required this.flightDetailModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const listItems = ["All", "Meal", "Beverage", "Equipment", "Towel"];
    final checkedStates = useState<List<bool>>(List.filled(listItems.length, false));
    final controller = ref.watch(flightPrinterBindingProvider.notifier);

    void toggleCheckbox(int index) {
      checkedStates.value = [
        for (int i = 0; i < checkedStates.value.length; i++)
          i == index ? !checkedStates.value[i] : checkedStates.value[i],
      ];
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppbarDialog(title: 'In phiếu - ${flightDetailModel.flight?.flightNo ?? "N/A"}',),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listItems.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: ConstomCheckbox(
                  title: listItems[index],
                  isChecked: checkedStates.value[index],
                  onTap: () => toggleCheckbox(index),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomButton(
              width: ScreenSize.width * 0.4,
              color: AppColors.primary,
              text: "In phiếu",
              fontSize: 14,
              onPressed: () async {
                final selectedItems = listItems
                    .asMap()
                    .entries
                    .where((entry) => checkedStates.value[entry.key])
                    .map((entry) => entry.value)
                    .toList();                
                    await controller.printJson(
                  context: context,
                  flightDetail: flightDetailModel,
                  selectedItems: selectedItems,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}