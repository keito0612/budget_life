// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'balance_with_saving.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BalanceWithSaving _$BalanceWithSavingFromJson(Map<String, dynamic> json) {
  return _BalanceWithSaving.fromJson(json);
}

/// @nodoc
mixin _$BalanceWithSaving {
  String get date => throw _privateConstructorUsedError;
  int get balance => throw _privateConstructorUsedError;
  int get saving => throw _privateConstructorUsedError;
  int get remainingBalance => throw _privateConstructorUsedError;
  int get remainingSaving => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BalanceWithSavingCopyWith<BalanceWithSaving> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BalanceWithSavingCopyWith<$Res> {
  factory $BalanceWithSavingCopyWith(
          BalanceWithSaving value, $Res Function(BalanceWithSaving) then) =
      _$BalanceWithSavingCopyWithImpl<$Res, BalanceWithSaving>;
  @useResult
  $Res call(
      {String date,
      int balance,
      int saving,
      int remainingBalance,
      int remainingSaving});
}

/// @nodoc
class _$BalanceWithSavingCopyWithImpl<$Res, $Val extends BalanceWithSaving>
    implements $BalanceWithSavingCopyWith<$Res> {
  _$BalanceWithSavingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? balance = null,
    Object? saving = null,
    Object? remainingBalance = null,
    Object? remainingSaving = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      saving: null == saving
          ? _value.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as int,
      remainingBalance: null == remainingBalance
          ? _value.remainingBalance
          : remainingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSaving: null == remainingSaving
          ? _value.remainingSaving
          : remainingSaving // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BalanceWithSavingImplCopyWith<$Res>
    implements $BalanceWithSavingCopyWith<$Res> {
  factory _$$BalanceWithSavingImplCopyWith(_$BalanceWithSavingImpl value,
          $Res Function(_$BalanceWithSavingImpl) then) =
      __$$BalanceWithSavingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String date,
      int balance,
      int saving,
      int remainingBalance,
      int remainingSaving});
}

/// @nodoc
class __$$BalanceWithSavingImplCopyWithImpl<$Res>
    extends _$BalanceWithSavingCopyWithImpl<$Res, _$BalanceWithSavingImpl>
    implements _$$BalanceWithSavingImplCopyWith<$Res> {
  __$$BalanceWithSavingImplCopyWithImpl(_$BalanceWithSavingImpl _value,
      $Res Function(_$BalanceWithSavingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? balance = null,
    Object? saving = null,
    Object? remainingBalance = null,
    Object? remainingSaving = null,
  }) {
    return _then(_$BalanceWithSavingImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      saving: null == saving
          ? _value.saving
          : saving // ignore: cast_nullable_to_non_nullable
              as int,
      remainingBalance: null == remainingBalance
          ? _value.remainingBalance
          : remainingBalance // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSaving: null == remainingSaving
          ? _value.remainingSaving
          : remainingSaving // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BalanceWithSavingImpl implements _BalanceWithSaving {
  const _$BalanceWithSavingImpl(
      {this.date = "",
      this.balance = 0,
      this.saving = 0,
      this.remainingBalance = 0,
      this.remainingSaving = 0});

  factory _$BalanceWithSavingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BalanceWithSavingImplFromJson(json);

  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final int balance;
  @override
  @JsonKey()
  final int saving;
  @override
  @JsonKey()
  final int remainingBalance;
  @override
  @JsonKey()
  final int remainingSaving;

  @override
  String toString() {
    return 'BalanceWithSaving(date: $date, balance: $balance, saving: $saving, remainingBalance: $remainingBalance, remainingSaving: $remainingSaving)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BalanceWithSavingImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.saving, saving) || other.saving == saving) &&
            (identical(other.remainingBalance, remainingBalance) ||
                other.remainingBalance == remainingBalance) &&
            (identical(other.remainingSaving, remainingSaving) ||
                other.remainingSaving == remainingSaving));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, balance, saving, remainingBalance, remainingSaving);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BalanceWithSavingImplCopyWith<_$BalanceWithSavingImpl> get copyWith =>
      __$$BalanceWithSavingImplCopyWithImpl<_$BalanceWithSavingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BalanceWithSavingImplToJson(
      this,
    );
  }
}

abstract class _BalanceWithSaving implements BalanceWithSaving {
  const factory _BalanceWithSaving(
      {final String date,
      final int balance,
      final int saving,
      final int remainingBalance,
      final int remainingSaving}) = _$BalanceWithSavingImpl;

  factory _BalanceWithSaving.fromJson(Map<String, dynamic> json) =
      _$BalanceWithSavingImpl.fromJson;

  @override
  String get date;
  @override
  int get balance;
  @override
  int get saving;
  @override
  int get remainingBalance;
  @override
  int get remainingSaving;
  @override
  @JsonKey(ignore: true)
  _$$BalanceWithSavingImplCopyWith<_$BalanceWithSavingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
