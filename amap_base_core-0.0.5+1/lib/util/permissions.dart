import 'package:permission_handler/permission_handler.dart';

class Permissions {
  /// 请求地图相关权限
  static Future<bool> requestMapPermission() async {
    final permissions = await PermissionHandler().requestPermissions([
      PermissionGroup.location,
      PermissionGroup.storage,
      PermissionGroup.phone,
    ]);

    if (permissions.values.any((status) => status == PermissionStatus.denied)) {
      return false;
    } else {
      return true;
    }
  }
}
