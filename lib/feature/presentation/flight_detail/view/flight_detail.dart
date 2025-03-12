import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/loading_overlay.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/filght_bool_state.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/filght_supplyfrom_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class FlightDetail extends ConsumerStatefulWidget {
  const FlightDetail({required this.id, super.key});
  final String id;

  @override
  ConsumerState<FlightDetail> createState() => _FlightDetailState();
}

class _FlightDetailState extends ConsumerState<FlightDetail> {
  String? _cachedId;

  @override
  void initState() {
    super.initState();
    _fetchFlightData();
  }

  @override
  void didUpdateWidget(FlightDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_cachedId != widget.id) _fetchFlightData();
  }

  void _fetchFlightData() {
    _cachedId = widget.id;
    Future.microtask(() {
      ref.read(flightDetailControllerProvider.notifier).fetchFlightDetail(widget.id);
      ref.read(flightSupplyFromProvider.notifier).fetchSupplyForm("78634FDB-729E-41D0-8D51-0005FD8011CD");
    });
  }

  void _navigateToSignature(BuildContext context) => context.push(AppRouter.flightSignature);
  void _showPrinterDialog(BuildContext context) => showDialog(context: context, builder: (_) => const FlightPrinter());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = ResponsiveHelper.isTablet(context);
    final isWeb = ResponsiveHelper.isWeb(context);
    final flightDetailAsync = ref.watch(flightDetailControllerProvider);
    final flightSupplyAsync = ref.watch(flightSupplyFromProvider);
    final isExpanded = ref.watch(isExpandedProvider);
    final flightBoolNotifier = ref.read(isEditProvider.notifier);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Cung ứng vật tư',
        iconRightFirst: Icons.file_present_outlined,
        colorFirst: AppColors.primary,
        onPressedFirst: () => _showPrinterDialog(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWeb ? width * 0.3 : isTablet ? width * 0.1 : 16,
          vertical: 16,
        ),
        child: Column(
          children: [
            flightDetailAsync.when(
              data: (data) => CustomDetailFlight(flightDetail: 'Chi tiết chuyến bay:', flightDetailModel: data),
              loading: () => SizedBox(height: 100, child: ColoredBox(color: AppColors.backgroundTab)),
              error: (error, _) => Center(child: Text('Lỗi: $error')),
            ),
            const TitleRowAll(title: 'DANH SÁCH', subtitle: 'Xem hết'),
            Expanded(
              child: flightSupplyAsync.when(
                error: (error, _) => Center(child: Text('Lỗi: $error')),
                loading: () => const LoadingOverlay(isLoading: true, child: Center(child: CircularProgressIndicator())),
                data: (supplyForms) => ListView.builder(
                  itemCount: supplyForms.length,
                  itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CupertinoContextMenu(
                      actions: [
                        CupertinoContextMenuAction(
                          onPressed: () => _navigateToSignature(context),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: AppColors.primary),
                              SizedBox(width: 10),
                              TextWidget(text: 'Ký xác nhận', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ],
                      child: Material(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.backgroundTab,
                        child: InkWell(
                          onTap: flightBoolNotifier.toggleExpansion,
                          child: CustomExpansionTile(
                            backgroundColor: AppColors.backgroundTab,
                            title: supplyForms[index].supplyFormCode.toString(),
                            subtitle: 'Mã code: ${supplyForms[index].supplyFormCode}',
                            leadingIcon: Icons.airplane_ticket,
                            trailingCount: '${supplyForms[index].totalSupply}',
                            confirmationText: 'Đã Xác nhận',
                            isExpanded: isExpanded,
                            onTap: flightBoolNotifier.toggleExpansion,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CustomButton(
              horizontalPadding: 16,
              onPressed: () => _navigateToSignature(context),
              color: AppColors.primary,
              text: 'Ký xác nhận',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class TitleRowAll extends StatelessWidget {
  const TitleRowAll({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w500),
            TextWidget(text: subtitle, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
          ],
        ),
      );
}