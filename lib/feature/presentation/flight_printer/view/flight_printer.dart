import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/appbar_dialog.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/constom_checkbox.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SupplyFilterType {
  all,
  meal,
  drink,
  equipment,
  towel,
  cart,
}

extension SupplyFilterTypeExtension on SupplyFilterType {
  String get label {
    switch (this) {
      case SupplyFilterType.all:
        return 'All';
      case SupplyFilterType.meal:
        return 'Meal';
      case SupplyFilterType.drink:
        return 'Drink';
      case SupplyFilterType.equipment:
        return 'Equipment';
      case SupplyFilterType.towel:
        return 'Towel';
      case SupplyFilterType.cart:
        return 'Cart';
    }
  }
}

class FlightPrinter extends HookConsumerWidget {
  final String flightId;
  final SupplyFormModel flightDetailModel;

  const FlightPrinter({super.key, required this.flightDetailModel , required this.flightId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listItems = SupplyFilterType.values;
    final checkedStates =
        useState<List<bool>>(List.filled(listItems.length, false));

    void toggleCheckbox(int index) {
      final newCheckedStates = List<bool>.from(checkedStates.value);

      if (index == 0) {
        final check = !newCheckedStates[0];
        for (int i = 0; i < newCheckedStates.length; i++) {
          newCheckedStates[i] = check;
        }
      } else {
        newCheckedStates[index] = !newCheckedStates[index];
        final allOthersChecked = listItems
            .asMap()
            .entries
            .skip(1)
            .every((entry) => newCheckedStates[entry.key]);
        newCheckedStates[0] = allOthersChecked;
      }

      checkedStates.value = newCheckedStates;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppbarDialog(
              title:
                  'In phiếu - ${flightDetailModel.flightInfo?.flightNo ?? "N/A"}',
            ),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listItems.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: ConstomCheckbox(
                  title: listItems[index].label,
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
                    .where((item) => item != SupplyFilterType.all)
                    .toList();

                // await controller.printJson(...);
                final selectedLabels =
                    selectedItems.map((e) => e.label).toList();

                GoRouter.of(context).push(AppRouter.preview,
                    extra: PreviewArgs(
                        flightId: flightId,
                        type: selectedLabels));
              },
            ),
          ],
        ),
      ),
    );
  }
}
