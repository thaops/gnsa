// import 'dart:io';
// import 'package:flutter_web/common/repositoty/dio_api.dart';
// import 'package:get/get.dart';
// import 'package:flutter_web/common/Services/api_endpoints.dart';
// import 'package:flutter_web/common/constants/http_status_codes.dart';
// import 'package:dio/dio.dart' as dio;

// class UploadImage {
//   DioApi dioApi = DioApi();

//   Future<void> uploadImage(List<File> selectedImages,
//       RxList<String> uploadImageList, RxBool isLoading) async {
//     try {
//       isLoading.value = true;
//       dio.FormData formData = dio.FormData.fromMap({});
//       for (var image in selectedImages) {
//         String fileName = image.path.split('/').last;
//         if (!fileName.endsWith('.jpg')) {
//           fileName = fileName.split('.').first + '.jpg';
//         }
//         formData.files.add(
//           MapEntry('file',
//               await dio.MultipartFile.fromFile(image.path, filename: fileName)),
//         );
//       }
//       final response = await dioApi.post(
//         ApiEndpoints.uploadImage,
//         data: formData,
//       );
//       if (uploadImageList.isNotEmpty) {
//         uploadImageList.clear();
//       }
//       if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
//         uploadImageList
//             .addAll(List<String>.from(response.data['data'] as List));
//       }
//     } catch (e) {
//       print(e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }