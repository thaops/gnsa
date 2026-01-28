import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/widgets/async_value_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supply_type_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/supply_type_provider.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/appbar_dialog.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/constom_checkbox.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlightPrinter extends HookConsumerWidget {
  final String flightId;
  final SupplyFormModel flightDetailModel;

  const FlightPrinter(
      {super.key, required this.flightDetailModel, required this.flightId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supplyTypesAsync = ref.watch(supplyTypeProviderProvider);

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
            AsyncValueWidget<List<SupplyTypeModel>>(
              value: supplyTypesAsync,
              data: (data) {
                // Add 'All' option
                final listItems = [
                  const SupplyTypeModel(key: 'All', value: 'All'),
                  ...data
                ];

                return _SupplyTypeSelectionList(
                  listItems: listItems,
                  flightId: flightId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SupplyTypeSelectionList extends HookWidget {
  final List<SupplyTypeModel> listItems;
  final String flightId;

  const _SupplyTypeSelectionList({
    required this.listItems,
    required this.flightId,
  });

  @override
  Widget build(BuildContext context) {
    final checkedStates =
        useState<List<bool>>(List.filled(listItems.length, false));

    void toggleCheckbox(int index) {
      final newCheckedStates = List<bool>.from(checkedStates.value);

      if (index == 0) {
        // Clicked All
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

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: listItems.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: ConstomCheckbox(
              title: listItems[index].value,
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
          onPressed: () {
            final selectedItems = listItems
                .asMap()
                .entries
                .where((entry) => checkedStates.value[entry.key])
                .map((entry) => entry.value)
                .where((item) => item.key != 'All')
                .toList();

            final selectedKeys =
                selectedItems.map((e) => e.key.toString()).toList();

            GoRouter.of(context).push(AppRouter.preview,
                extra: PreviewArgs(flightId: flightId, type: selectedKeys));
          },
        ),
      ],
    );
  }
}
