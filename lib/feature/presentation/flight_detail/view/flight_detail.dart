import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/method_channel/printer_plugin.dart'
    show UrovoPrinter;
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/loading_overlay.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/filght_bool_state.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart'
    show FlightDetailModel;
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
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
      ref
          .read(flightDetailControllerProvider.notifier)
          .fetchFlightDetail(widget.id);
    });
  }

  void _navigateToSignature(BuildContext context ,List<String> supplyfromId) =>
      context.push(AppRouter.flightSignature, extra: supplyfromId);
  void _showPrinterDialog(BuildContext context) => showDialog(
      context: context,
      builder: (_) => FlightPrinter(
            flightDetailModel: ref.watch(flightDetailControllerProvider).value!,
          ));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isTablet = ResponsiveHelper.isTablet(context);
    final isWeb = ResponsiveHelper.isWeb(context);
    final horizontalPadding = isWeb
        ? width * 0.3
        : isTablet
            ? width * 0.1
            : 16.0;
    final flightDetailAsync = ref.watch(flightDetailControllerProvider);
    final isExpanded = ref.watch(isChildExpandedProvider);
    final flightBoolNotifier = ref.read(isEditProvider.notifier);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Cung ứng vật tư',
        iconRightFirst: Icons.file_present_outlined,
        colorFirst: AppColors.primary,
        onPressedFirst: () => _showPrinterDialog(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Center(
                  child: Column(
                    children: [
                      flightDetailAsync.when(
                        error: (error, _) => Center(child: Text('Lỗi: $error')),
                        loading: () =>  LoadingOverlay(isLoading: true, child: SizedBox.fromSize(size: Size(height, width))),
                        data: (data) => _buildSupplyfromData(data, context, isExpanded, flightBoolNotifier),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: CustomButton(
              horizontalPadding: 16,
              onPressed: (){},
              color: AppColors.primary,
              text: 'Ký xác nhận',
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Column _buildSupplyfromData(FlightDetailModel data, BuildContext context, bool isExpanded, FlightBoolState flightBoolNotifier) {
    return Column(
                        children: [
                          CustomDetailFlight(
                              flightDetail: 'Chi tiết chuyến bay:',
                              flightDetailModel: data),
                          TitleRowAll(
                              title: 'DANH SÁCH',
                              subtitle: 'Xem hết',
                              onClickseenAll: () {
                                ref.read(isChildExpandedProvider.notifier).toggle();
                              }),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.supplyForms?.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CupertinoContextMenu(
                                actions: [
                                  CupertinoContextMenuAction(
                                    onPressed: () {
                                        _navigateToSignature(context, [data.supplyForms![index].supplyFormId!]);
                                        },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.edit,
                                            color: AppColors.primary),
                                        SizedBox(width: 10),
                                        TextWidget(
                                            text: 'Ký xác nhận',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Material(
                                  borderRadius: BorderRadius.circular(18),
                                  color: AppColors.backgroundTab,
                                  child: CustomExpansionTile(
                                    backgroundColor: AppColors.backgroundTab,
                                    title: data.supplyForms![index].className
                                        .toString(),
                                    subtitle:
                                        'Mã code: ${data.supplyForms?[index].supplyFormCode}',
                                    leadingIcon: Icons.airplane_ticket,
                                    trailingCount:
                                        '${data.supplyForms?[index].totalSupply}',
                                    isConfirmed:
                                        data.supplyForms?[index].status !=
                                            'NotSign',
                                    isExpanded: isExpanded,
                                    onTap: flightBoolNotifier.toggle,
                                    supplyForm: data.supplyForms?[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
  }
}

class TitleRowAll extends StatelessWidget {
  const TitleRowAll(
      {required this.title,
      required this.subtitle,
      super.key,
      required this.onClickseenAll});

  final String title;
  final String subtitle;
  final Function() onClickseenAll;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w500),
            InkWell(
              onTap: () => onClickseenAll(),
              child: TextWidget(
                  text: subtitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary),
            ),
          ],
        ),
      );
}
