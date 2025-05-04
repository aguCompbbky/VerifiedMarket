import 'package:foodapp/utils/services/connection.dart';

abstract class UpdateStrategy {
  Future<bool> update(String currentEmail, String newValue);
}

class EmailUpdateStrategy implements UpdateStrategy {
  @override
  Future<bool> update(String currentEmail, String newValue) {
    return Connection.updateUserField(currentEmail, "email", newValue);
  }
}

class UsernameUpdateStrategy implements UpdateStrategy {
  @override
  Future<bool> update(String currentEmail, String newValue) {
    return Connection.updateUserField(currentEmail, "username", newValue);
  }
}

class PasswordUpdateStrategy implements UpdateStrategy {
  @override
  Future<bool> update(String currentEmail, String newValue) {
    return Connection.updateUserField(currentEmail, "password", newValue);
  }
}
