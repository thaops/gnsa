// flight_detail_screen.dart
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
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/filght_bool_state.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/popup_information_sign.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/child_loading_list.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlightDetailScreen extends HookConsumerWidget {
  const FlightDetailScreen({required this.id, super.key});
  final String id;

  static const String _kValueSign = "NotSign";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedId = useState<String?>(null);
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = _getHorizontalPadding(size.width, context);

    useEffect(() {
      if (cachedId.value != id) {
        cachedId.value = id;
        Future.microtask(() => ref
            .read(flightDetailControllerProvider.notifier)
            .fetchFlightDetail(id));
      }
      return null;
    }, [id]);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref, horizontalPadding),
    );
  }

  double _getHorizontalPadding(double width, BuildContext context) =>
      ResponsiveHelper.isWeb(context)
          ? width * 0.3
          : ResponsiveHelper.isTablet(context)
              ? width * 0.1
              : 16.0;

  AppBarWidget _buildAppBar(BuildContext context, WidgetRef ref) =>
      AppBarWidget(
        title: 'Cung ứng vật tư',
        iconRightFirst: Icons.file_present_outlined,
        colorFirst: AppColors.primary,
        onPressedFirst: () => _showPrinterDialog(context, ref),
      );

  Widget _buildBody(
          BuildContext context, WidgetRef ref, double horizontalPadding) =>
      Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              child: _buildContent(context, ref),
            ),
          ),
          _buildSignButton(context, ref, horizontalPadding),
          const SizedBox(height: 16),
        ],
      );

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final flightDetailAsync = ref.watch(flightDetailControllerProvider);
    final isExpanded = ref.watch(isChildExpandedProvider);
    final flightBoolNotifier = ref.read(isEditProvider.notifier);

    return Center(
      child: flightDetailAsync.when(
        error: (error, _) => Center(child: Text('Lỗi: $error')),
        loading: () => _buildLoading(),
        data: (data) => _buildSupplyFormList(
          data,
          context,
          isExpanded,
          flightBoolNotifier,
          ref,
        ),
      ),
    );
  }

  LoadingShimmer _buildLoading() {
    return const LoadingShimmer(
        child: Column(
      children: [
        ContainerLoading(
          height: 150,
        ),
        TitleRowAll(
          title: 'DANH SÁCH',
          subtitle: 'Xem hết',
        ),
        ChildLoadingList(
            child: ContainerLoading(
          height: 70,
        ))
      ],
    ));
  }

  Widget _buildSupplyFormList(
    FlightDetailModel data,
    BuildContext context,
    bool isExpanded,
    FlightBoolState flightBoolNotifier,
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
            onClickSeenAll: () =>
                ref.read(isChildExpandedProvider.notifier).toggle(),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.supplyForms?.length ?? 0,
            itemBuilder: (_, index) => _buildSupplyItem(
              context,
              data.supplyForms![index],
              isExpanded,
              flightBoolNotifier,
            ),
          ),
        ],
      );

  Widget _buildSupplyItem(
    BuildContext context,
    SupplyForm supplyForm,
    bool isExpanded,
    FlightBoolState flightBoolNotifier,
  ) =>
      Padding(
        padding: EdgeInsets.only(bottom: 16.h),
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
            borderRadius: BorderRadius.circular(18.r),
            color: AppColors.backgroundTab,
            child: CustomExpansionTile(
              backgroundColor: AppColors.backgroundTab,
              title: " ${supplyForm.category.toString()} - ${supplyForm.className.toString()}",
              subtitle: 'Mã code: ${supplyForm.supplyFormCode}',
              leadingIcon: Icons.airplane_ticket,
              trailingCount: '${supplyForm.totalSupply}',
              isConfirmed: supplyForm.status != _kValueSign,
              isExpanded: isExpanded,
              onTap: flightBoolNotifier.toggle,
              supplyForm: supplyForm,
              onConfirm: () => {
                showDialog(
                    context: context,
                    builder: (context) => PopupInformationSign(
                          supplyfromId: supplyForm.supplyFormId!,
                        ))
              },
            ),
          ),
        ),
      );

  Widget _buildSignButton(
    BuildContext context,
    WidgetRef ref,
    double horizontalPadding,
  ) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: CustomButton(
          horizontalPadding: 16,
          onPressed: () => _handleSignButton(context, ref),
          color: AppColors.primary,
          text: 'Ký xác nhận',
        ),
      );

  void _handleSignButton(BuildContext context, WidgetRef ref) {
    ref.watch(flightDetailControllerProvider).whenData((data) {
      final filterSupplyForm =
          data.supplyForms!.where((e) => e.status == _kValueSign).toList();
      final supplyFormIds =
          filterSupplyForm.map((e) => e.supplyFormId!).toList();

      if (supplyFormIds.isEmpty) {
        CustomFlushbar.showError(context,
            message: 'Không có dữ liệu để ký xác nhận');
        return;
      }
      context.push(AppRouter.flightSignature, extra: supplyFormIds);
    });
  }

  void _showPrinterDialog(BuildContext context, WidgetRef ref) => showDialog(
        context: context,
        builder: (_) => FlightPrinter(
          flightDetailModel: ref.watch(flightDetailControllerProvider).value!,
        ),
      );
}

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
        padding: const EdgeInsets.symmetric(vertical: 16),
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
