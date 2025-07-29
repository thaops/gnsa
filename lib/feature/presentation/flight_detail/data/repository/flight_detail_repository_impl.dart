import 'package:gnsa/feature/presentation/flight_detail/data/data_sources/flight_detail_remote.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_add_req_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/card_item_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/preview_args.dart';
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

  @override
  Future<FlightPreviewModel> getFlightPreview(PreviewArgs args) {
    return _flightDetailRemote.getFlightPreview(args);
  }

  @override
  Future<List<CardItemModel>> getListCart() {
    return _flightDetailRemote.getListCart();
  }

  @override
  Future<bool> addCardItem(CardAddReqModel req) {
    return _flightDetailRemote.addCardItem(req);
  }
  
  @override
  Future<String> getQr(String flightId) {
    return _flightDetailRemote.getQr(flightId);
  }
}