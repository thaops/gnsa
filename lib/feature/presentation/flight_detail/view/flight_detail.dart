import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/preview_view.dart';
import 'package:gnsa/feature/presentation/flight_detail/view/supply_form_list_view.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_loading_case.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kValueSign = 'NotSigned';
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
    final state = ref.watch(
        flightDetailProviderProvider(id));
    return 
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context, ref, state, id),
        body: _buildBody(context, ref, state),
      );
    
  }

  void _showPrinterDialog(BuildContext context, WidgetRef ref, AsyncValue<SupplyFormModel> state) {
    state.when(
      data: (data) => showDialog(
        context: context,
        builder: (_) => FlightPrinter(flightDetailModel: data, flightId: id),
      ),
      loading: () => const SizedBox(),
      error: (error, stack) => StateErr(error: error.toString()),
    );
  }

  double _getHorizontalPadding(double width, BuildContext context) {
    if (ResponsiveHelper.isWeb(context)) return width * _paddingWebRatio;
    if (ResponsiveHelper.isTablet(context)) return width * _paddingTabletRatio;
    return _paddingHorizontalMobile;
  }

  AppBarWidget _buildAppBar(BuildContext context, WidgetRef ref, AsyncValue<SupplyFormModel> state, String flightId) {
    return AppBarWidget(
      title: 'Cung ứng vật tư',
      isBack: true,
      isTitleCenter: true,
      popupMenuItems: [
        PopupMenuItem<String>(
          value: 'preview',
          child: Row(
            children: [
              Icon(Icons.file_present_outlined,
                  color: AppColors.primary, size: 18.sp),
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
            _showPrinterDialog(context, ref, state);
            break;
          case 'qr':
            context.push(AppRouter.qrcode);
            break;
          case 'preview':
            context.push(AppRouter.preview, extra: PreviewArgs(flightId: flightId));
            break;
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AsyncValue<SupplyFormModel> state) {
    List<String> idsNotSign = [];
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = _getHorizontalPadding(size.width, context);
    return state.when(
      data: (data) {
        data.supplyFormDetails?.forEach((element) {
          if (element.status == _kValueSign) {
            idsNotSign.add(element.supplyFormDetailId);
          }
        });
        
        if (data.supplyFormId == null &&
            data.supplyFormDetails?.isEmpty == true) {
          return const Center(child: Text('Không có chi tiết chuyến bay'));
        }
        return KeepAliveFlightDetailContent(
          data: data,
          horizontalPadding: horizontalPadding,
          ref: ref,
          ids: idsNotSign,
          flightId: id,
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: LoadingShimmer(
          child: CustomLoadingCase(),
        ),
      ),
      error: (error, stack) => StateErr(error: error.toString()),
    );
  }
}

class KeepAliveFlightDetailContent extends StatefulWidget {
  final SupplyFormModel data;
  final double horizontalPadding;
  final WidgetRef ref;
  final List<String> ids;
  final String flightId;

  const KeepAliveFlightDetailContent({
    super.key,
    required this.data,
    required this.horizontalPadding,
    required this.ref,
    required this.ids,
    required this.flightId,
  });

  @override
  _KeepAliveFlightDetailContentState createState() =>
      _KeepAliveFlightDetailContentState();
}

class _KeepAliveFlightDetailContentState
    extends State<KeepAliveFlightDetailContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HookBuilder(
      builder: (context) {
        final tabController = useTabController(initialLength: 2);
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding,
                  vertical: _paddingVertical,
                ),
                child: _buildSupplyFormList(
                  widget.data,
                  context,
                  // widget.ref.watch(isChildExpandedProviderProvider),
                  widget.ref,
                  tabController,
                ),
              ),
            ),
          widget.ids.isEmpty ? const SizedBox() :  _buildSignButton(
                context, widget.ref, widget.horizontalPadding, widget.ids, widget.flightId),
            const SizedBox(height: _paddingVertical),
          ],
        );
      },
    );
  }

  Widget _buildSupplyFormList(
    SupplyFormModel data,
    BuildContext context,
    // bool isExpanded,
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
                  // isExpanded: isExpanded,
                  ref: ref,
                  isAdditional: false,
                  kValueSign: _kValueSign,
                ),
                SupplyFormListView(
                  supplyForms: data.additionalFormDetails,
                  ref: ref,
                  isAdditional: true,
                  kValueSign: _kValueSign,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildSignButton(BuildContext context, WidgetRef ref,
          double horizontalPadding, List<String> id, String flightId) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: CustomButton(
          horizontalPadding: _buttonHorizontalPadding,
          onPressed: () {
            context.push(AppRouter.flightSignature, extra: id).then((value) {
              if (value == true) {
                Future.microtask(() => ref.invalidate(flightDetailProviderProvider(flightId)));
              }
            });
          },
          color: AppColors.primary,
          text: 'Ký xác nhận',
        ),
      );
}
