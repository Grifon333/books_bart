import 'package:shared_preferences/shared_preferences.dart';

class OrderDataProviderKeys {
  static const orderId = 'order_id';
}

class OrderDataProvider {
  final _storage = SharedPreferences.getInstance();

  Future<void> setOrderId(String orderId) async {
    await (await _storage).setString(OrderDataProviderKeys.orderId, orderId);
  }

  Future<String?> getOrderId() async {
    return (await _storage).getString(OrderDataProviderKeys.orderId);
  }

  Future<void> deleteOrderId() async {
    (await _storage).remove(OrderDataProviderKeys.orderId);
  }
}