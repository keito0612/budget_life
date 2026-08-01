import 'package:budget/datebases/transfer_database.dart';
import 'package:budget/model/transfer/transfer.dart';
import 'package:budget/repositorys/transfer_repository.dart';
import 'package:budget/states/transfer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transferViewModelProvider =
    StateNotifierProvider<TransferViewModel, TransferState>(
  (ref) => TransferViewModel(
    ref,
    TransferRepository(TransferDatabase()),
  ),
);

class TransferViewModel extends StateNotifier<TransferState> {
  TransferViewModel(this._ref, this._transferRepository)
      : super(const TransferState()) {
    getTransfers();
  }
  final Ref _ref;
  final TransferRepository _transferRepository;

  Future<void> addTransfer(Transfer transfer) async {
    final transferData = await _transferRepository.addTransfer(transfer);
    state = state.copyWith(transfers: [transferData, ...state.transfers]);
  }

  Future<void> getTransfers() async {
    final transfers = await _transferRepository.getTransfers();
    state = state.copyWith(
      transfers: transfers,
    );
  }

  Future<void> updateTransfer(Transfer transfer) async {
    await _transferRepository.updateTransfer(transfer);

    final transfers = await _transferRepository.getTransfers();
    state = state.copyWith(
      transfers: transfers,
    );
  }

  Future<void> deleteTransfer(int transferId) async {
    await _transferRepository.deleteTransfer(transferId);
    final transfers =
        state.transfers.where((transfer) => transfer.id != transferId).toList();
    state = state.copyWith(
      transfers: transfers,
    );
  }

  Future<void> transferAllDelete() async {
    await _transferRepository.rawDelete();
    getTransfers();
  }
}
