import 'package:budget/model/transfer/transfer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'transfer_state.freezed.dart';

@freezed
abstract class TransferState with _$TransferState {
  const factory TransferState({@Default([]) List<Transfer> transfers}) =
      _TransferState;
}
