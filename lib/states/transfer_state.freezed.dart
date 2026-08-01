// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TransferState {
  List<Transfer> get transfers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransferStateCopyWith<TransferState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferStateCopyWith<$Res> {
  factory $TransferStateCopyWith(
          TransferState value, $Res Function(TransferState) then) =
      _$TransferStateCopyWithImpl<$Res, TransferState>;
  @useResult
  $Res call({List<Transfer> transfers});
}

/// @nodoc
class _$TransferStateCopyWithImpl<$Res, $Val extends TransferState>
    implements $TransferStateCopyWith<$Res> {
  _$TransferStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transfers = null,
  }) {
    return _then(_value.copyWith(
      transfers: null == transfers
          ? _value.transfers
          : transfers // ignore: cast_nullable_to_non_nullable
              as List<Transfer>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferStateImplCopyWith<$Res>
    implements $TransferStateCopyWith<$Res> {
  factory _$$TransferStateImplCopyWith(
          _$TransferStateImpl value, $Res Function(_$TransferStateImpl) then) =
      __$$TransferStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Transfer> transfers});
}

/// @nodoc
class __$$TransferStateImplCopyWithImpl<$Res>
    extends _$TransferStateCopyWithImpl<$Res, _$TransferStateImpl>
    implements _$$TransferStateImplCopyWith<$Res> {
  __$$TransferStateImplCopyWithImpl(
      _$TransferStateImpl _value, $Res Function(_$TransferStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transfers = null,
  }) {
    return _then(_$TransferStateImpl(
      transfers: null == transfers
          ? _value._transfers
          : transfers // ignore: cast_nullable_to_non_nullable
              as List<Transfer>,
    ));
  }
}

/// @nodoc

class _$TransferStateImpl implements _TransferState {
  const _$TransferStateImpl({final List<Transfer> transfers = const []})
      : _transfers = transfers;

  final List<Transfer> _transfers;
  @override
  @JsonKey()
  List<Transfer> get transfers {
    if (_transfers is EqualUnmodifiableListView) return _transfers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transfers);
  }

  @override
  String toString() {
    return 'TransferState(transfers: $transfers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferStateImpl &&
            const DeepCollectionEquality()
                .equals(other._transfers, _transfers));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_transfers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferStateImplCopyWith<_$TransferStateImpl> get copyWith =>
      __$$TransferStateImplCopyWithImpl<_$TransferStateImpl>(this, _$identity);
}

abstract class _TransferState implements TransferState {
  const factory _TransferState({final List<Transfer> transfers}) =
      _$TransferStateImpl;

  @override
  List<Transfer> get transfers;
  @override
  @JsonKey(ignore: true)
  _$$TransferStateImplCopyWith<_$TransferStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
