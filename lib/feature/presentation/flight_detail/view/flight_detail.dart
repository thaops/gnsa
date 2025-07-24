import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/filght_bool_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/supply_form_list_view.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kValueSign = 'NotSign';
const _paddingVertical = 16.0;
const _paddingHorizontalMobile = 16.0;
const _paddingWebRatio = 0.3;
const _paddingTabletRatio = 0.1;
const _buttonHorizontalPadding = 16.0;

class FlightDetailScreen extends HookConsumerWidget {
  const FlightDetailScreen({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final cachedId = useState<String?>(null);
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = _getHorizontalPadding(size.width, context);

    useEffect(() {
      if (cachedId.value != id) {
        cachedId.value = id;
        Future.microtask(() => ref
            .read(flightDetailProviderProvider.notifier)
            .fetchFlightDetail(id));
      }
      return () => tabController.dispose();
    }, [id]);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context, ref),
        body: _buildBody(
            horizontalPadding,
            ref.watch(flightDetailProviderProvider).value ??
               SupplyFormModel(),
            context,
            ref,
            tabController));
  }

  void _handleSignButton(BuildContext context, WidgetRef ref) {
    ref.watch(flightDetailProviderProvider).whenData((data) {
      final filterSupplyForm =
          data.supplyFormDetails?.where((e) => e.supplyType == _kValueSign).toList() ??
              [];
      final supplyFormIds =
          filterSupplyForm.map((e) => e.supplyFormDetailId!).toList();
      if (supplyFormIds.isEmpty) {
        CustomFlushbar.showError(context,
            message: 'Không có dữ liệu để ký xác nhận');
        return;
      }
      context.push(AppRouter.flightSignature, extra: supplyFormIds);
    });
  }

  void _showPrinterDialog(BuildContext context, WidgetRef ref) {
    final flightDetail = ref.watch(flightDetailProviderProvider).value;
    showDialog(
      context: context,
      builder: (_) => flightDetail == null
          ? const StateErr()
          : FlightPrinter(flightDetailModel: flightDetail),
    );
  }

  double _getHorizontalPadding(double width, BuildContext context) {
    if (ResponsiveHelper.isWeb(context)) return width * _paddingWebRatio;
    if (ResponsiveHelper.isTablet(context)) return width * _paddingTabletRatio;
    return _paddingHorizontalMobile;
  }

AppBarWidget _buildAppBar(BuildContext context, WidgetRef ref) {
  return AppBarWidget(
    title: 'Cung ứng vật tư',
    isBack: true,
    isTitleCenter: true,
    popupMenuItems: [
      PopupMenuItem<String>(
        value: 'preview',
        child: Row(
          children: [
            Icon(Icons.file_present_outlined, color: AppColors.primary, size: 18.sp),
            SizedBox(width: 8.w),
            TextWidget(
              text: 'Xem trước',
              fontSize: 14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'qr',
        child: Row(
          children: [
            Icon(Icons.qr_code, color: AppColors.primary, size: 18.sp),
            SizedBox(width: 8.w),
            TextWidget(
              text: 'Mã QR',
              fontSize: 14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'printer',
        child: Row(
          children: [
            Icon(Icons.print, color: AppColors.primary, size: 18.sp),
            SizedBox(width: 8.w),
            TextWidget(
              text: 'In',
              fontSize: 14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    ],
    onPopupMenuSelected: (value) {
      switch (value) {
        case 'printer':
          _showPrinterDialog(context, ref);
          break;
        case 'qr':
          context.push(AppRouter.qrcode);
          break;
        case 'preview':
          context.push(AppRouter.preview);
          break;
      }
    },
  );
}
  Widget _buildBody(double horizontalPadding, SupplyFormModel data,
      BuildContext context, WidgetRef ref, TabController tabController) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: _paddingVertical),
            child: _buildSupplyFormList(
              data,
              context,
              ref.watch(isChildExpandedProviderProvider),
              ref,
              tabController,
            ),
          ),
        ),
        _buildSignButton(context, ref, horizontalPadding),
        const SizedBox(height: _paddingVertical),
      ],
    );
  }

  Widget _buildSupplyFormList(
    SupplyFormModel data,
    BuildContext context,
    bool isExpanded,
    WidgetRef ref,
    TabController tabController,
  ) =>
      Column(
        children: [
          CustomDetailFlight(
            flightDetail: 'Chi tiết chuyến bay:',
            supplyFormModel: data,
          ),
          TabBar(
            controller: tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                child: SizedBox(
                  width: AppSizes.tabWidth,
                  child: Text(
                    'Phiếu cung ứng',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Tab(
                child: SizedBox(
                  width: AppSizes.tabWidth,
                  child: Text(
                    'Phiếu bổ sung',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
         Flexible(
           child: TabBarView(
                controller: tabController,
                children: [
                  SupplyFormListView(
                    supplyForms: data.supplyFormDetails,
                    isExpanded: isExpanded,
                    ref: ref,
                    kValueSign: _kValueSign,
                  ),
                  SupplyFormListView(
                    supplyForms: data.additionalFormDetails,
                    isExpanded: isExpanded,
                    ref: ref,
                    kValueSign: _kValueSign,
                  ),
                ],
              ),
         ),
        ],
      );

  Widget _buildSignButton(
          BuildContext context, WidgetRef ref, double horizontalPadding) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: CustomButton(
          horizontalPadding: _buttonHorizontalPadding,
          onPressed: () => _handleSignButton(context, ref),
          color: AppColors.primary,
          text: 'Ký xác nhận',
        ),
      );
}
