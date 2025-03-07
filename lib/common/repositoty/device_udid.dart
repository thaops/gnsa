import 'package:get_storage/get_storage.dart';

class DeviceUdid {
  final GetStorage _storage;

  DeviceUdid(this._storage);

  static Future<DeviceUdid> createDeviceUdid() async {
    return DeviceUdid(GetStorage());
  }

  Future<void> saveUdid(String udid) async {
    await _storage.write('udid', udid); // Lưu udid
  }
  Future<String> getUdid() async {
    String? token = _storage.read('udid'); // Lấy udid
    return token ?? ''; // Trả về udid hoặc chuỗi rỗng
  }
  Future<void> deleteUdid() async {
    await _storage.remove('udid'); // Xóa udid
  }
}
