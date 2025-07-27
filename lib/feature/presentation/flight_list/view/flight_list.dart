import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_list/provider/flight_list_provider.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/flight_list_content.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _searchDebounceDuration = Duration(seconds: 1);
const _loadingItemHeight = 60.0;
const _listItemVerticalPadding = 16.0;

class FlightListScreen extends HookConsumerWidget {
  final bool isMyFlight;
  const FlightListScreen({super.key, required this.isMyFlight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeepAliveFlightListContent(isMyFlight: isMyFlight);
  }
}

class KeepAliveFlightListContent extends StatefulWidget {
  final bool isMyFlight;

  const KeepAliveFlightListContent({super.key, required this.isMyFlight});

  @override
  _KeepAliveFlightListContentState createState() =>
      _KeepAliveFlightListContentState();
}

class _KeepAliveFlightListContentState extends State<KeepAliveFlightListContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HookConsumer(
      builder: (context, ref, child) {
        final searchController = useTextEditingController();
        final currentSearch = useState('');
        final debounce = useState<Timer?>(null);

        useEffect(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(flightListNotifierProvider(widget.isMyFlight).notifier)
                .refreshFlights();
          });
          return () {
            debounce.value?.cancel();
          };
        }, [widget.isMyFlight]);

        void onSearchChanged(String value) {
          debounce.value?.cancel();
          debounce.value = Timer(_searchDebounceDuration, () {
            currentSearch.value = value;
            ref
                .read(flightListNotifierProvider(widget.isMyFlight).notifier)
                .refreshFlights(
                  search: value.isEmpty ? null : value,
                );
          });
        }

        return Scaffold(
          appBar: AppBarWidget(
            title: widget.isMyFlight ? 'Lịch bay của tôi' : 'Toàn bộ lịch bay',
            isBack: false,
          ),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _listItemVerticalPadding.h),
            child: Column(
              children: [
                _buildSearchField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onClear: () {
                    searchController.clear();
                    currentSearch.value = '';
                    ref
                        .read(flightListNotifierProvider(widget.isMyFlight)
                            .notifier)
                        .refreshFlights();
                  },
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final flightsAsync = ref
                          .watch(flightListNotifierProvider(widget.isMyFlight));
                      return flightsAsync.when(
                        loading: () => LoadingShimmer(
                          type: LoadingShimmerType.list,
                          child: ContainerLoading(),
                        ),
                        error: (error, stack) =>
                            StateErr(error: error.toString()),
                        data: (flights) => FlightListContent(
                          flights: flights,
                          searchText: currentSearch.value,
                          isMyFlight: widget.isMyFlight,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required VoidCallback onClear,
  }) {
    return CustomTextField(
      hintText: 'Tìm kiếm',
      controller: controller,
      prefixIcon: Icons.search,
      borderWidth: 0,
      keyboardType: TextInputType.text,
      backgroundColor: AppColors.backgroundTab,
      borderRadius: 20,
      suffixIcon: controller.text.isEmpty ? null : Icons.clear,
      onSuffixTap: onClear,
      onChanged: onChanged,
    );
  }
}
