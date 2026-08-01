import 'package:budget/datebases/transfer_database.dart';
import 'package:budget/model/transfer/transfer.dart';

class TransferRepository {
  final TransferDatabase _transferDatabase;

  TransferRepository(this._transferDatabase);

  Future<List<Transfer>> getTransfers() async {
    return _transferDatabase.getTransfers();
  }

  Future<Transfer> addTransfer(Transfer transfer) async {
    return _transferDatabase.insert(transfer);
  }

  Future<void> updateTransfer(Transfer transfer) async {
    return _transferDatabase.update(transfer);
  }

  Future<void> deleteTransfer(int id) async {
    return _transferDatabase.delete(id);
  }

  Future<void> rawDelete() {
    return _transferDatabase.rawDelete();
  }
}
