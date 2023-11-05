// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$IncomeState {
  List<Income> get incomes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IncomeStateCopyWith<IncomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeStateCopyWith<$Res> {
  factory $IncomeStateCopyWith(
          IncomeState value, $Res Function(IncomeState) then) =
      _$IncomeStateCopyWithImpl<$Res, IncomeState>;
  @useResult
  $Res call({List<Income> incomes});
}

/// @nodoc
class _$IncomeStateCopyWithImpl<$Res, $Val extends IncomeState>
    implements $IncomeStateCopyWith<$Res> {
  _$IncomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incomes = null,
  }) {
    return _then(_value.copyWith(
      incomes: null == incomes
          ? _value.incomes
          : incomes // ignore: cast_nullable_to_non_nullable
              as List<Income>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeStateImplCopyWith<$Res>
    implements $IncomeStateCopyWith<$Res> {
  factory _$$IncomeStateImplCopyWith(
          _$IncomeStateImpl value, $Res Function(_$IncomeStateImpl) then) =
      __$$IncomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Income> incomes});
}

/// @nodoc
class __$$IncomeStateImplCopyWithImpl<$Res>
    extends _$IncomeStateCopyWithImpl<$Res, _$IncomeStateImpl>
    implements _$$IncomeStateImplCopyWith<$Res> {
  __$$IncomeStateImplCopyWithImpl(
      _$IncomeStateImpl _value, $Res Function(_$IncomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? incomes = null,
  }) {
    return _then(_$IncomeStateImpl(
      incomes: null == incomes
          ? _value._incomes
          : incomes // ignore: cast_nullable_to_non_nullable
              as List<Income>,
    ));
  }
}

/// @nodoc

class _$IncomeStateImpl implements _IncomeState {
  const _$IncomeStateImpl({final List<Income> incomes = const []})
      : _incomes = incomes;

  final List<Income> _incomes;
  @override
  @JsonKey()
  List<Income> get incomes {
    if (_incomes is EqualUnmodifiableListView) return _incomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incomes);
  }

  @override
  String toString() {
    return 'IncomeState(incomes: $incomes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeStateImpl &&
            const DeepCollectionEquality().equals(other._incomes, _incomes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_incomes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeStateImplCopyWith<_$IncomeStateImpl> get copyWith =>
      __$$IncomeStateImplCopyWithImpl<_$IncomeStateImpl>(this, _$identity);
}

abstract class _IncomeState implements IncomeState {
  const factory _IncomeState({final List<Income> incomes}) = _$IncomeStateImpl;

  @override
  List<Income> get incomes;
  @override
  @JsonKey(ignore: true)
  _$$IncomeStateImplCopyWith<_$IncomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
