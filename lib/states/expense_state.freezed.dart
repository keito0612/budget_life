// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExpenseState {
  List<Expense> get expenses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpenseStateCopyWith<ExpenseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseStateCopyWith<$Res> {
  factory $ExpenseStateCopyWith(
          ExpenseState value, $Res Function(ExpenseState) then) =
      _$ExpenseStateCopyWithImpl<$Res, ExpenseState>;
  @useResult
  $Res call({List<Expense> expenses});
}

/// @nodoc
class _$ExpenseStateCopyWithImpl<$Res, $Val extends ExpenseState>
    implements $ExpenseStateCopyWith<$Res> {
  _$ExpenseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenses = null,
  }) {
    return _then(_value.copyWith(
      expenses: null == expenses
          ? _value.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ExpenseStateCopyWith<$Res>
    implements $ExpenseStateCopyWith<$Res> {
  factory _$$_ExpenseStateCopyWith(
          _$_ExpenseState value, $Res Function(_$_ExpenseState) then) =
      __$$_ExpenseStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Expense> expenses});
}

/// @nodoc
class __$$_ExpenseStateCopyWithImpl<$Res>
    extends _$ExpenseStateCopyWithImpl<$Res, _$_ExpenseState>
    implements _$$_ExpenseStateCopyWith<$Res> {
  __$$_ExpenseStateCopyWithImpl(
      _$_ExpenseState _value, $Res Function(_$_ExpenseState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenses = null,
  }) {
    return _then(_$_ExpenseState(
      expenses: null == expenses
          ? _value._expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as List<Expense>,
    ));
  }
}

/// @nodoc

class _$_ExpenseState implements _ExpenseState {
  const _$_ExpenseState({final List<Expense> expenses = const []})
      : _expenses = expenses;

  final List<Expense> _expenses;
  @override
  @JsonKey()
  List<Expense> get expenses {
    if (_expenses is EqualUnmodifiableListView) return _expenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenses);
  }

  @override
  String toString() {
    return 'ExpenseState(expenses: $expenses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExpenseState &&
            const DeepCollectionEquality().equals(other._expenses, _expenses));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_expenses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExpenseStateCopyWith<_$_ExpenseState> get copyWith =>
      __$$_ExpenseStateCopyWithImpl<_$_ExpenseState>(this, _$identity);
}

abstract class _ExpenseState implements ExpenseState {
  const factory _ExpenseState({final List<Expense> expenses}) = _$_ExpenseState;

  @override
  List<Expense> get expenses;
  @override
  @JsonKey(ignore: true)
  _$$_ExpenseStateCopyWith<_$_ExpenseState> get copyWith =>
      throw _privateConstructorUsedError;
}
