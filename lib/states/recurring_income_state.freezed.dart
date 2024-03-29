// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_income_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecurringIncomeState {
  List<RecurringIncome> get recurringIncomes =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecurringIncomeStateCopyWith<RecurringIncomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringIncomeStateCopyWith<$Res> {
  factory $RecurringIncomeStateCopyWith(RecurringIncomeState value,
          $Res Function(RecurringIncomeState) then) =
      _$RecurringIncomeStateCopyWithImpl<$Res, RecurringIncomeState>;
  @useResult
  $Res call({List<RecurringIncome> recurringIncomes});
}

/// @nodoc
class _$RecurringIncomeStateCopyWithImpl<$Res,
        $Val extends RecurringIncomeState>
    implements $RecurringIncomeStateCopyWith<$Res> {
  _$RecurringIncomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurringIncomes = null,
  }) {
    return _then(_value.copyWith(
      recurringIncomes: null == recurringIncomes
          ? _value.recurringIncomes
          : recurringIncomes // ignore: cast_nullable_to_non_nullable
              as List<RecurringIncome>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurringIncomeStateImplCopyWith<$Res>
    implements $RecurringIncomeStateCopyWith<$Res> {
  factory _$$RecurringIncomeStateImplCopyWith(_$RecurringIncomeStateImpl value,
          $Res Function(_$RecurringIncomeStateImpl) then) =
      __$$RecurringIncomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<RecurringIncome> recurringIncomes});
}

/// @nodoc
class __$$RecurringIncomeStateImplCopyWithImpl<$Res>
    extends _$RecurringIncomeStateCopyWithImpl<$Res, _$RecurringIncomeStateImpl>
    implements _$$RecurringIncomeStateImplCopyWith<$Res> {
  __$$RecurringIncomeStateImplCopyWithImpl(_$RecurringIncomeStateImpl _value,
      $Res Function(_$RecurringIncomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recurringIncomes = null,
  }) {
    return _then(_$RecurringIncomeStateImpl(
      recurringIncomes: null == recurringIncomes
          ? _value._recurringIncomes
          : recurringIncomes // ignore: cast_nullable_to_non_nullable
              as List<RecurringIncome>,
    ));
  }
}

/// @nodoc

class _$RecurringIncomeStateImpl implements _RecurringIncomeState {
  const _$RecurringIncomeStateImpl(
      {final List<RecurringIncome> recurringIncomes = const []})
      : _recurringIncomes = recurringIncomes;

  final List<RecurringIncome> _recurringIncomes;
  @override
  @JsonKey()
  List<RecurringIncome> get recurringIncomes {
    if (_recurringIncomes is EqualUnmodifiableListView)
      return _recurringIncomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recurringIncomes);
  }

  @override
  String toString() {
    return 'RecurringIncomeState(recurringIncomes: $recurringIncomes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringIncomeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._recurringIncomes, _recurringIncomes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_recurringIncomes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringIncomeStateImplCopyWith<_$RecurringIncomeStateImpl>
      get copyWith =>
          __$$RecurringIncomeStateImplCopyWithImpl<_$RecurringIncomeStateImpl>(
              this, _$identity);
}

abstract class _RecurringIncomeState implements RecurringIncomeState {
  const factory _RecurringIncomeState(
          {final List<RecurringIncome> recurringIncomes}) =
      _$RecurringIncomeStateImpl;

  @override
  List<RecurringIncome> get recurringIncomes;
  @override
  @JsonKey(ignore: true)
  _$$RecurringIncomeStateImplCopyWith<_$RecurringIncomeStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
