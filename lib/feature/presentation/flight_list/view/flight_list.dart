import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/provider/flight_list_provider.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/child_loading_list.dart';
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
    final currentSearch = useState('');

    final focusNode = useFocusNode();

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent * 0.8 &&
            !isLoadingMore.value) {
          _loadMore(ref, currentSearch.value, isLoadingMore);
        }
      });
      return () {
        scrollController.dispose();
        debounce.value?.cancel();
        searchController.dispose();
      };
    }, []);

    void _logout() async {
      final services = await Services.create();
      await services.deleteAccessToken();
      GoRouter.of(context).go(AppRouter.login);
    }
    void _onChangedSearch(String value) {
      if (value.isEmpty) {
        ref.read(flightListProvider.notifier).refreshFlights();
      } else {
        currentSearch.value = value;
        ref.read(flightListProvider.notifier).refreshFlights(search: value);
      }
    }

    void _clearSearch() {
      focusNode.unfocus();
      searchController.clear();
      currentSearch.value = '';
      ref.read(flightListProvider.notifier).refreshFlights();
    }

    final flightListAsync = ref.watch(flightListProvider);
    return Scaffold(
      appBar: AppBarWidget(
        title: "Lịch bay",
        isBack: false,
        iconRightSecond: Icons.logout,
        onPressedSecond: () => _logout(),
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
              keyboardType: TextInputType.text,
              backgroundColor: AppColors.backgroundTab,
              borderRadius: 20,
              focusNode: focusNode,
              suffixIcon: searchController.text.isEmpty ? null : Icons.clear,
              onSuffixTap: () {
                _clearSearch();
              },
              onPrefixTap: () {
               focusNode.unfocus();
              },
              borderColor: AppColors.backgroundTab,
              onChanged: (value) {
                debounce.value?.cancel();
                debounce.value = Timer(const Duration(seconds: 1), () {
                  _onChangedSearch(value);
                });
              },
            ),
            _buildFlightList(flightListAsync, scrollController, isLoadingMore,
                context, ref, currentSearch.value),
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (ResponsiveHelper.isWeb(context))
      return EdgeInsets.symmetric(horizontal: screenWidth * 0.3);
    if (ResponsiveHelper.isTablet(context))
      return EdgeInsets.symmetric(horizontal: screenWidth * 0.1);
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
        loading: () => _buildLoading(),
        error: (error, stack) => Center(child: Text("Lỗi: $error")),
        data: (flightsModel) {
          if (flightsModel.data.isEmpty) {
            return const Center(child: Text("Không có chuyến bay nào."));
          }
          return _buildFlights(scrollController, flightsModel, isLoadingMore);
        },
      ),
    );
  }

  LoadingShimmer _buildLoading() {
    return const LoadingShimmer(
      child: ChildLoadingList(
        child: ContainerLoading(),
      ),
    );
  }

  Column _buildFlights(ScrollController scrollController,
      FlightsModel flightsModel, ValueNotifier<bool> isLoadingMore) {
    final int itemCount = isLoadingMore.value
        ? flightsModel.data.length + 1
        : flightsModel.data.length;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == flightsModel.data.length) {
                return LoadingShimmer(child: ContainerLoading(height: 60.h));
              }
              final flightData = flightsModel.data[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: CustomFlightList(
                  data: flightData,
                  onTap: () {
                    GoRouter.of(context)
                        .push(AppRouter.flightDetail, extra: flightData.id);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _loadMore(
    WidgetRef ref, String searchText, ValueNotifier<bool> isLoadingMore) async {
  isLoadingMore.value = true;
  await ref.read(flightListProvider.notifier).loadMore(search: searchText);
  isLoadingMore.value = false;
}