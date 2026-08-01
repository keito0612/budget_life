import 'package:freezed_annotation/freezed_annotation.dart';
part 'transfer.freezed.dart';
part 'transfer.g.dart';

@freezed
abstract class Transfer with _$Transfer {
  const factory Transfer({
    int? id,
    @Default(0) int fromWalletId,
    @Default(0) int toWalletId,
    @Default("") String amount,
    @Default("") String date,
    @Default("") String memo,
  }) = _Transfer;
  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}
