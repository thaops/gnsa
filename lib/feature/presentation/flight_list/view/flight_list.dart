import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/loading_overlay.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/provider/flight_list_provider.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/custom_flight_list.dart';
import 'package:gnsa/router/app_router.dart' show AppRouter;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlightList extends HookConsumerWidget {
  const FlightList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final isLoadingMore = useState(false);
    final debounce = useState<Timer?>(null);
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent * 0.8 &&
            !isLoadingMore.value) {
          _loadMore(ref, searchController.text, isLoadingMore);
        }
      });
      return () {
        scrollController.dispose();
        debounce.value?.cancel();
        searchController.dispose();
      };
    }, []);
    final flightListAsync = ref.watch(flightListProvider);
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Lịch bay",
        isBack: false,
      ),
      body: Container(
        color: AppColors.white,
        padding: _getPadding(context),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Tìm kiếm",
              controller: searchController,
              prefixIcon: Icons.search,
              borderWidth: 0,
              backgroundColor: AppColors.backgroundTab,
              borderRadius: 20,
              borderColor: AppColors.backgroundTab,
              onChanged: (value) {
                debounce.value?.cancel();
                debounce.value = Timer(const Duration(seconds: 1), () {
                  ref.read(flightListProvider.notifier).refreshFlights(search: value);
                });
              },
            ),
            _buildFlightList(flightListAsync, scrollController, isLoadingMore, context, ref, searchController.text),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (ResponsiveHelper.isWeb(context)) return EdgeInsets.symmetric(horizontal: screenWidth * 0.3);
    if (ResponsiveHelper.isTablet(context)) return EdgeInsets.symmetric(horizontal: screenWidth * 0.1);
    return const EdgeInsets.symmetric(horizontal: 26);
  }

  Expanded _buildFlightList(
    AsyncValue<FlightsModel> flightListAsync,
    ScrollController scrollController,
    ValueNotifier<bool> isLoadingMore,
    BuildContext context,
    WidgetRef ref,
    String searchText,
  ) {
    return Expanded(
      child: flightListAsync.when(
        loading: () => const LoadingOverlay(
          isLoading: true,
          child: Scaffold(),
        ),
        error: (error, stack) => Center(child: Text("Lỗi: $error")),
        data: (flightsModel) {
          if (flightsModel.data.isEmpty) {
            return const Center(child: Text("Không có chuyến bay nào."));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: flightsModel.data.length,
                  itemBuilder: (context, index) {
                    final flightData = flightsModel.data[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: CustomFlightList(
                        data: flightData,
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.flightDetail, extra: flightData.id);
                        },
                      ),
                    );
                  },
                ),
              ),
              if (isLoadingMore.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> _loadMore(WidgetRef ref, String searchText, ValueNotifier<bool> isLoadingMore) async {
  isLoadingMore.value = true;
  await ref.read(flightListProvider.notifier).loadMore(search: searchText);
  isLoadingMore.value = false;
}