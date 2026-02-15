import 'package:internet_connection_checker/internet_connection_checker.dart';

// 1. العقد (Interface)
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// 2. التنفيذ (Implementation)
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
