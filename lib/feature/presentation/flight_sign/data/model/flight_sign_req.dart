import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';


class FlightSignReq {
  final List<String> supplyFormDetailIds;
  final String signedName;
  final bool isCrew;
  final File signedFile;

  FlightSignReq({
    required this.supplyFormDetailIds,
    required this.signedName,
    required this.isCrew,
    required this.signedFile,
  });

  Future<FormData> toFormData() async {
    final formMap = <String, dynamic>{};

    // Gửi danh sách từng ID đúng theo multipart
    for (var id in supplyFormDetailIds) {
      formMap.putIfAbsent('SupplyFormDetailIds', () => []).add(id);
    }

    formMap.addAll({
      'SignedName': signedName,
      'IsCrew': isCrew.toString(),
      'Signed': await MultipartFile.fromFile(
        signedFile.path,
        filename: signedFile.path.split('/').last,
        contentType: MediaType('image', 'png'),
      ),
    });

    return FormData.fromMap(formMap);
  }

  Map<String, dynamic> toJson() => {
        'SupplyFormDetailIds': supplyFormDetailIds,
        'SignedName': signedName,
        'IsCrew': isCrew,
        'Signed': signedFile.path,
      };
}
