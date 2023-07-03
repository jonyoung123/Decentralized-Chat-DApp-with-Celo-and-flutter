import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final String _addressKey = 'address';
  final String _usernameKey = 'identifier';
  final String _isCreatedKey = 'didCreated';
  final String _celoDid = 'celoDid';

  Future<dynamic> setUserAddress(String address) async {
    await storage.write(key: _addressKey, value: address);
  }

  Future<dynamic> setUsername(String username) async {
    await storage.write(key: _usernameKey, value: username);
  }

  Future<dynamic> setCreatedBoolean() async {
    await storage.write(key: _isCreatedKey, value: 'true');
  }

  Future<dynamic> getUserAddress() async {
    String? address = await storage.read(key: _addressKey);
    return address;
  }

  Future<dynamic> getUsername() async {
    String? username = await storage.read(key: _usernameKey);
    return username;
  }

  Future<dynamic> getCreatedBoolean() async {
    String? boolKey = await storage.read(key: _isCreatedKey);
    return boolKey;
  }
}
