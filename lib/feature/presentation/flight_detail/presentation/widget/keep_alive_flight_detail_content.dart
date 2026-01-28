import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/flight_detail_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/ids_not_sign_provider.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/provider/providers.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/view/flight_detail.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/view/supply_form_list_view.dart';
import 'package:gnsa/feature/presentation/flight_detail/presentation/widget/custom_detail_flight.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_ag.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kValueSign = 'NotSigned';
const _paddingVertical = 16.0;

class KeepAliveFlightDetailContent extends StatefulWidget {
  final SupplyFormModel data;
  final double horizontalPadding;
  final WidgetRef ref;
  final String flightId;

  const KeepAliveFlightDetailContent({
    super.key,
    required this.data,
    required this.horizontalPadding,
    required this.ref,
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
                Column(
                  children: [
                    Expanded(
                      child: SupplyFormListView(
                        supplyForms: data.supplyFormDetails,
                        flightId: widget.flightId,
                        isAdditional: false,
                        kValueSign: _kValueSign,
                        isSupplement: false,
                      ),
                    ),
                    ref.watch(idsNotSignProvider).isEmpty
                        ? const SizedBox()
                        : _buildSignButton(
                            context,
                            widget.ref,
                            widget.horizontalPadding,
                            ref.watch(idsNotSignProvider),
                            widget.flightId,
                            false),
                    // const SizedBox(height: _paddingVertical),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: SupplyFormListView(
                        supplyForms: data.additionalFormDetails,
                        flightId: widget.flightId,
                        isAdditional: true,
                        kValueSign: _kValueSign,
                        isSupplement: true,
                      ),
                    ),
                    ref.watch(idsNotSignAdditionalProvider).isEmpty
                        ? const SizedBox()
                        : _buildSignButton(
                            context,
                            widget.ref,
                            widget.horizontalPadding,
                            ref.watch(idsNotSignAdditionalProvider),
                            widget.flightId,
                            true),
                    // const SizedBox(height: _paddingVertical),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildSignButton(
          BuildContext context,
          WidgetRef ref,
          double horizontalPadding,
          List<String> id,
          String flightId,
          bool isSupplement) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: CustomButton(
          // horizontalPadding: _buttonHorizontalPadding,
          onPressed: () async {
            final result = await context.push(AppRouter.flightSignature,
                extra: FlightSignatureAg(
                    supplyformdetailId: id,
                    isSupplement: isSupplement,
                    isSignAll: true));

            if (result == true) {
              try {
                await ref
                    .refresh(flightDetailProviderProvider(flightId).future);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã ký xác nhận thành công')),
                  );
                }
              } catch (e) {
                ref.invalidate(flightDetailProviderProvider(flightId));
              }
            }
          },

          color: AppColors.primary,
          text: 'Ký xác nhận',
        ),
      );
}
