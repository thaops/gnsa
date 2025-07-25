import 'package:gnsa/feature/presentation/flight_detail/data/data_sources/flight_detail_remote.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/update_supplyfrom_item_req.dart';
import 'package:gnsa/feature/presentation/flight_detail/domain/repository/flight_detail_repository.dart';

class FlightDetailRepositoryImpl implements FlightDetailRepository {
  final FlightDetailRemote _flightDetailRemote;
  FlightDetailRepositoryImpl(this._flightDetailRemote);
  @override
  Future<SupplyFormModel> getFlightDetail(String id) async {
    return await _flightDetailRemote.getFlightDetail(id);
  }

  @override
  Future<String> updateSupplyfromItemDetail(UpdateSupplyfromItemReq req) {
    return _flightDetailRemote.updateSupplyfromItemDetail(req);
  }
}