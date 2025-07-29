import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/feature/presentation/flight_list/data/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/provider/flight_list_provider.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/custom_flight_list.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _scrollThreshold = 0.8;

class FlightListContent extends HookConsumerWidget {
  final FlightsModel flights;
  final String searchText;
  final bool isMyFlight;

  const FlightListContent({
    required this.flights,
    required this.searchText,
    required this.isMyFlight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final isLoadingMore = useState(false);

    // useEffect(() {
    //   void listener() {
    //     if (scrollController.position.pixels >=
    //         scrollController.position.maxScrollExtent * _scrollThreshold) {
    //       isLoadingMore.value = true;
    //       ref.read(flightListNotifierProvider(isMyFlight).notifier)
    //           .loadMore(search: searchText)
    //           .then((_) => isLoadingMore.value = false);
    //     }
    //   }
    //   scrollController.addListener(listener);
    //   return () => scrollController.removeListener(listener);
    // }, [searchText]);

    // if (flights.data == null || flights.data!.isEmpty) {
    //   return const Center(
    //     child: Text('Không tìm thấy chuyến bay phù hợp'),
    //   );
    // }

    useEffect(() {
      void listener() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent * _scrollThreshold) {
          if (!isLoadingMore.value) {
            isLoadingMore.value = true;
            ref
                .read(flightListNotifierProvider(isMyFlight).notifier)
                .loadMore(search: searchText)
                .then((_) {
              isLoadingMore.value = false;
            });
          }
        }
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController, searchText]);

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(flightListNotifierProvider(isMyFlight).notifier)
            .refreshFlights(search: searchText);
      },
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: flights.data!.length + (isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == flights.data!.length) {
            return LoadingShimmer(child: ContainerLoading());
          }
          final flightData = flights.data![index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium.w),
            child: CustomFlightList(
              data: flightData,
              onTap: () => GoRouter.of(context).push(
                AppRouter.flightDetail,
                extra: "D4AFFD21-22F7-4AFA-AD88-008A08D077C0",
              ),
            ),
          );
        },
      ),
    );
  }
}
