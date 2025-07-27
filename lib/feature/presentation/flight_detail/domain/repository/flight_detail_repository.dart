import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';

abstract class FlightDetailRepository {
  Future<SupplyFormModel> getFlightDetail(String id);
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req);
  Future<FlightPreviewModel> getFlightPreview(String flightId);
}

class FlightDetailUserCase {
  final FlightDetailRepository repository;

  FlightDetailUserCase(this.repository);

  Future<SupplyFormModel> call(String id) async {
    return await repository.getFlightDetail(id);
  }

  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req) async {
    return await repository.updateSupplyfromItemDetail(req);
  }

  Future<FlightPreviewModel> getFlightPreview(String flightId) async {
    return await repository.getFlightPreview(flightId);
  }
}