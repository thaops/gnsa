import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/utils/custom_dialog.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/state_err.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/provider/flight_list_provider.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/child_loading_list.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/custom_flight_list.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Hằng số cấu hình
const _searchDebounceDuration = Duration(seconds: 1);
const _scrollThreshold = 0.8; // Ngưỡng cuộn để tải thêm (80% chiều dài danh sách)
const _paddingHorizontalMobile = 26.0;
const _paddingWebRatio = 0.3;
const _paddingTabletRatio = 0.1;
const _loadingItemHeight = 60.0;
const _listItemVerticalPadding = 16.0;

/// Widget hiển thị danh sách chuyến bay với khả năng tìm kiếm, tải thêm và đăng xuất
class FlightList extends HookConsumerWidget {
  const FlightList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Quản lý trạng thái với hooks
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final isLoadingMore = useState(false);
    final debounce = useState<Timer?>(null);
    final currentSearch = useState('');
    final focusNode = useFocusNode();

    // Lắng nghe cuộn để tải thêm dữ liệu
    useEffect(() {
      void scrollListener() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent * _scrollThreshold &&
            !isLoadingMore.value) {
          _loadMore(ref, currentSearch.value, isLoadingMore);
        }
      }

      scrollController.addListener(scrollListener);
      return () {
        scrollController.removeListener(scrollListener);
        scrollController.dispose();
        debounce.value?.cancel();
        searchController.dispose();
        focusNode.dispose();
      };
    }, [scrollController]);

    // Xử lý đăng xuất
    Future<void> _logout() async {
      final confirmed = await CustomDialog().showConfirmationDialog(
        context,
        'Xác nhận',
        'Bạn có chắc chắn muốn đăng xuất?',
      );
      if (confirmed == true) {
        final services = await Services.create();
        await services.deleteAccessToken();
        if (context.mounted) {
          GoRouter.of(context).go(AppRouter.login);
        }
      }
    }

    // Xử lý thay đổi tìm kiếm với debounce
    void _onSearchChanged(String value) {
      debounce.value?.cancel();
      debounce.value = Timer(_searchDebounceDuration, () {
        currentSearch.value = value;
        ref
            .read(flightListNotifierProvider.notifier)
            .refreshFlights(search: value.isEmpty ? null : value);
      });
    }

    // Xóa nội dung tìm kiếm
    void _clearSearch() {
      focusNode.unfocus();
      searchController.clear();
      currentSearch.value = '';
      ref.read(flightListNotifierProvider.notifier).refreshFlights();
    }

    // Lấy dữ liệu từ provider
    final flightListAsync = ref.watch(flightListNotifierProvider);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Lịch bay',
        isBack: false,
        iconRightSecond: Icons.logout,
        onPressedSecond: _logout,
      ),
      body: Container(
        color: AppColors.white,
        padding: _getPadding(context),
        child: Column(
          children: [
            _buildSearchField(
              controller: searchController,
              focusNode: focusNode,
              onChanged: _onSearchChanged,
              onClear: _clearSearch,
            ),
            _buildFlightListContent(
              flightListAsync: flightListAsync,
              scrollController: scrollController,
              isLoadingMore: isLoadingMore,
              context: context,
              ref: ref,
              searchText: currentSearch.value,
            ),
          ],
        ),
      ),
    );
  }

  /// Trả về padding dựa trên loại thiết bị
  EdgeInsets _getPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (ResponsiveHelper.isWeb(context)) {
      return EdgeInsets.symmetric(horizontal: screenWidth * _paddingWebRatio);
    }
    if (ResponsiveHelper.isTablet(context)) {
      return EdgeInsets.symmetric(horizontal: screenWidth * _paddingTabletRatio);
    }
    return const EdgeInsets.symmetric(horizontal: _paddingHorizontalMobile);
  }

  /// Tạo trường tìm kiếm
  Widget _buildSearchField({
    required TextEditingController controller,
    required FocusNode focusNode,
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
      focusNode: focusNode,
      suffixIcon: controller.text.isEmpty ? null : Icons.clear,
      onSuffixTap: onClear,
      onPrefixTap: focusNode.unfocus,
      borderColor: AppColors.backgroundTab,
      onChanged: onChanged,
    );
  }

  /// Tạo nội dung danh sách chuyến bay
  Widget _buildFlightListContent({
    required AsyncValue<FlightsModel> flightListAsync,
    required ScrollController scrollController,
    required ValueNotifier<bool> isLoadingMore,
    required BuildContext context,
    required WidgetRef ref,
    required String searchText,
  }) {
    return Expanded(
      child: flightListAsync.when(
        loading: () => _buildLoading(),
        error: (error, stack) => StateErr(error: error.toString()),
        data: (flightsModel) => _buildFlightData(
          flightsModel: flightsModel,
          scrollController: scrollController,
          isLoadingMore: isLoadingMore,
          context: context,
        ),
      ),
    );
  }

  /// Tạo giao diện khi đang tải
  Widget _buildLoading() {
    return const LoadingShimmer(
      child: ChildLoadingList(child: ContainerLoading()),
    );
  }

  /// Tạo danh sách chuyến bay hoặc thông báo rỗng
  Widget _buildFlightData({
    required FlightsModel flightsModel,
    required ScrollController scrollController,
    required ValueNotifier<bool> isLoadingMore,
    required BuildContext context,
  }) {
    if (flightsModel.data.isEmpty) {
      return const StateErr(error: 'Không tìm thấy chuyến bay');
    }
    return _buildFlightListView(
      flightsModel: flightsModel,
      scrollController: scrollController,
      isLoadingMore: isLoadingMore,
      context: context,
    );
  }

  /// Tạo danh sách chuyến bay với ListView
  Widget _buildFlightListView({
    required FlightsModel flightsModel,
    required ScrollController scrollController,
    required ValueNotifier<bool> isLoadingMore,
    required BuildContext context,
  }) {
    final itemCount =
        isLoadingMore.value ? flightsModel.data.length + 1 : flightsModel.data.length;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == flightsModel.data.length) {
                return LoadingShimmer(
                  child: ContainerLoading(height: _loadingItemHeight.h),
                );
              }
              final flightData = flightsModel.data[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: _listItemVerticalPadding.h),
                child: CustomFlightList(
                  data: flightData,
                  onTap: () => GoRouter.of(context).push(
                    AppRouter.flightDetail,
                    extra: flightData.id,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Tải thêm dữ liệu khi cuộn đến ngưỡng
  Future<void> _loadMore(
    WidgetRef ref,
    String searchText,
    ValueNotifier<bool> isLoadingMore,
  ) async {
    isLoadingMore.value = true;
    await ref.read(flightListNotifierProvider.notifier).loadMore(search: searchText);
    isLoadingMore.value = false;
  }
}