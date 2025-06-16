import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/filght_bool_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/popup_information_sign.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/child_loading_list.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Hằng số cấu hình
const _kValueSign = 'NotSign';
const _paddingVertical = 16.0;
const _paddingHorizontalMobile = 16.0;
const _paddingWebRatio = 0.3;
const _paddingTabletRatio = 0.1;
const _loadingHeightMain = 150.0;
const _loadingHeightChild = 70.0;
const _supplyItemBottomPadding = 16.0;
const _buttonHorizontalPadding = 16.0;
const _expansionTileRadius = 18.0;

/// Màn hình chi tiết chuyến bay
class FlightDetailScreen extends HookConsumerWidget {
  const FlightDetailScreen({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedId = useState<String?>(null);
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = _getHorizontalPadding(size.width, context);

    useEffect(() {
      if (cachedId.value != id) {
        cachedId.value = id;
        Future.microtask(() => ref.read(flightDetailProviderProvider.notifier).fetchFlightDetail(id));
      }
      return null;
    }, [id]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref, horizontalPadding),
    );
  }

  /// Tính toán padding ngang dựa trên thiết bị
  double _getHorizontalPadding(double width, BuildContext context) {
    if (ResponsiveHelper.isWeb(context)) return width * _paddingWebRatio;
    if (ResponsiveHelper.isTablet(context)) return width * _paddingTabletRatio;
    return _paddingHorizontalMobile;
  }

  /// Tạo AppBar
  AppBarWidget _buildAppBar(BuildContext context, WidgetRef ref) => AppBarWidget(
        title: 'Cung ứng vật tư',
        iconRightFirst: Icons.file_present_outlined,
        colorFirst: AppColors.primary,
        onPressedFirst: () => _showPrinterDialog(context, ref),
      );

  /// Tạo body
  Widget _buildBody(BuildContext context, WidgetRef ref, double horizontalPadding) {
    final flightDetailAsync = ref.watch(flightDetailProviderProvider);
    return flightDetailAsync.when(
      error: (error, _) => StateErr(error: error.toString()),
      loading: () => _buildLoading(horizontalPadding),
      data: (data) => _buildData(horizontalPadding, data, context, ref),
    );
  }

  /// Tạo giao diện khi có dữ liệu
  Column _buildData(double horizontalPadding, FlightDetailModel data, BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: _paddingVertical),
            child: _buildSupplyFormList(
              data,
              context,
              ref.watch(isChildExpandedProviderProvider),
              ref,
            ),
          ),
        ),
        _buildSignButton(context, ref, horizontalPadding),
        const SizedBox(height: _paddingVertical),
      ],
    );
  }

  /// Tạo giao diện khi đang tải
  LoadingShimmer _buildLoading(double horizontalPadding) => LoadingShimmer(
        child: _bodyState(
          horizontalPadding,
          const Column(
            children: [
              ContainerLoading(height: _loadingHeightMain),
              TitleRowAll(title: 'DANH SÁCH', subtitle: 'Xem hết'),
              ChildLoadingList(child: ContainerLoading(height: _loadingHeightChild)),
            ],
          ),
        ),
      );

  /// Tạo body với padding
  Widget _bodyState(double horizontalPadding, Widget child) => Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: _paddingVertical),
          child: child,
        ),
      );

  /// Tạo danh sách vật tư
  Widget _buildSupplyFormList(
    FlightDetailModel data,
    BuildContext context,
    bool isExpanded,
    WidgetRef ref,
  ) =>
      Column(
        children: [
          CustomDetailFlight(
            flightDetail: 'Chi tiết chuyến bay:',
            flightDetailModel: data,
          ),
          TitleRowAll(
            title: 'DANH SÁCH',
            subtitle: 'Xem hết',
            onClickSeenAll: () => ref.read(isChildExpandedProviderProvider.notifier).toggle(),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.supplyForms?.length ?? 0,
            itemBuilder: (_, index) => _buildSupplyItem(
              context,
              data.supplyForms![index],
              isExpanded,
              ref,
            ),
          ),
        ],
      );

  /// Tạo mục vật tư
  Widget _buildSupplyItem(
    BuildContext context,
    SupplyForm supplyForm,
    bool isExpanded,
    WidgetRef ref,
  ) =>
      Padding(
        padding: EdgeInsets.only(bottom: _supplyItemBottomPadding.h),
        child: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              onPressed: () => context.push(
                AppRouter.flightSignature,
                extra: [supplyForm.supplyFormId!],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit, color: AppColors.primary),
                  SizedBox(width: 10.w),
                  const TextWidget(
                    text: 'Ký xác nhận',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
          child: Material(
            borderRadius: BorderRadius.circular(_expansionTileRadius.r),
            color: AppColors.backgroundTab,
            child: CustomExpansionTile(
              backgroundColor: AppColors.backgroundTab,
              title: '${supplyForm.category} - ${supplyForm.className}',
              subtitle: 'Mã code: ${supplyForm.supplyFormCode}',
              leadingIcon: Icons.airplane_ticket,
              trailingCount: '${supplyForm.totalSupply}',
              isConfirmed: supplyForm.status != _kValueSign,
              isExpanded: isExpanded,
              onTap: () => ref.read(isChildExpandedProviderProvider.notifier).toggle(),
              supplyForm: supplyForm,
              onConfirm: () => showDialog(
                context: context,
                builder: (context) => PopupInformationSign(
                  supplyfromId: supplyForm.supplyFormId!,
                ),
              ),
            ),
          ),
        ),
      );

  /// Tạo nút ký xác nhận
  Widget _buildSignButton(BuildContext context, WidgetRef ref, double horizontalPadding) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: CustomButton(
          horizontalPadding: _buttonHorizontalPadding,
          onPressed: () => _handleSignButton(context, ref),
          color: AppColors.primary,
          text: 'Ký xác nhận',
        ),
      );

  /// Xử lý nhấn nút ký xác nhận
  void _handleSignButton(BuildContext context, WidgetRef ref) {
    ref.watch(flightDetailProviderProvider).whenData((data) {
      final filterSupplyForm = data.supplyForms?.where((e) => e.status == _kValueSign).toList() ?? [];
      final supplyFormIds = filterSupplyForm.map((e) => e.supplyFormId!).toList();
      if (supplyFormIds.isEmpty) {
        CustomFlushbar.showError(context, message: 'Không có dữ liệu để ký xác nhận');
        return;
      }
      context.push(AppRouter.flightSignature, extra: supplyFormIds);
    });
  }

  /// Hiển thị dialog in
  void _showPrinterDialog(BuildContext context, WidgetRef ref) {
    final flightDetail = ref.watch(flightDetailProviderProvider).value;
    showDialog(
      context: context,
      builder: (_) => flightDetail == null ? const StateErr() : FlightPrinter(flightDetailModel: flightDetail),
    );
  }
}

/// Widget tiêu đề với nút "Xem hết"
class TitleRowAll extends StatelessWidget {
  const TitleRowAll({
    required this.title,
    required this.subtitle,
    this.onClickSeenAll,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onClickSeenAll;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: _paddingVertical),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w500),
            InkWell(
              onTap: onClickSeenAll,
              child: TextWidget(
                text: subtitle,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
}