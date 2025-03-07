import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';
import 'package:gnsa/router/app_router.dart';

class FlightListController extends GetxController {
  final searchController = TextEditingController();
  FlightsModel? flightsModel =
      FlightsModel(data: [], statusCode: 0, message: '', totalRecord: 0);
  FlightsModel? flightsModelSearch =
      FlightsModel(data: [], statusCode: 0, message: '', totalRecord: 0);

  RxBool isLoading = false.obs;
  RxBool isSearch = false.obs;
  RxBool isScrolling = false.obs;
  RxBool isCheckloading = false.obs;
  final ScrollController scrollController = ScrollController();
  int pageIndex = 1;
  int pageSize = 20;
  int pageIndexSearch = 1;

  @override
  void onInit() {
    super.onInit();
    getFlights();
    scrollController.addListener(_scrollListener);
  }
  @override
void onClose() {
  searchController.dispose();
  scrollController.dispose();
  super.onClose();
}


  void onTapFlightItem() {
    Get.toNamed(AppRouter.flightDetail);
  }

  void _scrollListener() async {
    if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 2 / 3 &&
        !isLoading.value) {
      if (isSearch.value) {
        pageIndexSearch++;
        await getFlights(search: searchController.text);
      } else {
        isScrolling.value = true;
        await getFlights();
        pageIndex++;
      }
    }
  }

  Future<void> getFlights({String? search}) async {
    print("getFlights $pageIndex");
    final dioApi = DioApi();
    if (!isScrolling.value) {
      if ((search?.isEmpty ?? true) &&
          (flightsModel?.data.isNotEmpty ?? false)) {
        isSearch.value = false;
        return;
      }
    }
    try {
      isLoading.value = true;
      
      if (search?.isNotEmpty ?? false) {
        isSearch.value = true;
      }
      final response = await dioApi.get(
        ApiEndpoints.flightList,
        params: {
          "PageIndex": isSearch.value ? pageIndexSearch : pageIndex,
          "PageSize": pageSize,
          "Keyword": search
        },

      );

      final jsonData = FlightsModel.fromJson(response.data);
      if (isSearch.value) {
        if(pageIndexSearch == 1){
          flightsModelSearch = jsonData;
        } else {
          flightsModelSearch?.data.addAll(jsonData.data);
        }
      } else {
        pageIndexSearch = 1;
        flightsModel?.data.addAll(jsonData.data);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load flights');
    } finally {
      isScrolling.value = false;
      isLoading.value = false;
    }
  }
}
