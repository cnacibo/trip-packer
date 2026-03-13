import 'package:trip_packer/domain/repositories/auth_repository.dart';

class LogOutUseCase {
  final AuthRepository _repository;

  LogOutUseCase(this._repository);

  Future<bool> execute() {
    return _repository.signOut();
  }
}