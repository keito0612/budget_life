// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fixed_expense_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$fixedExpenseState {
  List<FixedExpense> get fixedExpenses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $fixedExpenseStateCopyWith<fixedExpenseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $fixedExpenseStateCopyWith<$Res> {
  factory $fixedExpenseStateCopyWith(
          fixedExpenseState value, $Res Function(fixedExpenseState) then) =
      _$fixedExpenseStateCopyWithImpl<$Res, fixedExpenseState>;
  @useResult
  $Res call({List<FixedExpense> fixedExpenses});
}

/// @nodoc
class _$fixedExpenseStateCopyWithImpl<$Res, $Val extends fixedExpenseState>
    implements $fixedExpenseStateCopyWith<$Res> {
  _$fixedExpenseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixedExpenses = null,
  }) {
    return _then(_value.copyWith(
      fixedExpenses: null == fixedExpenses
          ? _value.fixedExpenses
          : fixedExpenses // ignore: cast_nullable_to_non_nullable
              as List<FixedExpense>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$fixedExpenseStateImplCopyWith<$Res>
    implements $fixedExpenseStateCopyWith<$Res> {
  factory _$$fixedExpenseStateImplCopyWith(_$fixedExpenseStateImpl value,
          $Res Function(_$fixedExpenseStateImpl) then) =
      __$$fixedExpenseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<FixedExpense> fixedExpenses});
}

/// @nodoc
class __$$fixedExpenseStateImplCopyWithImpl<$Res>
    extends _$fixedExpenseStateCopyWithImpl<$Res, _$fixedExpenseStateImpl>
    implements _$$fixedExpenseStateImplCopyWith<$Res> {
  __$$fixedExpenseStateImplCopyWithImpl(_$fixedExpenseStateImpl _value,
      $Res Function(_$fixedExpenseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fixedExpenses = null,
  }) {
    return _then(_$fixedExpenseStateImpl(
      fixedExpenses: null == fixedExpenses
          ? _value._fixedExpenses
          : fixedExpenses // ignore: cast_nullable_to_non_nullable
              as List<FixedExpense>,
    ));
  }
}

/// @nodoc

class _$fixedExpenseStateImpl implements _fixedExpenseState {
  const _$fixedExpenseStateImpl(
      {final List<FixedExpense> fixedExpenses = const []})
      : _fixedExpenses = fixedExpenses;

  final List<FixedExpense> _fixedExpenses;
  @override
  @JsonKey()
  List<FixedExpense> get fixedExpenses {
    if (_fixedExpenses is EqualUnmodifiableListView) return _fixedExpenses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fixedExpenses);
  }

  @override
  String toString() {
    return 'fixedExpenseState(fixedExpenses: $fixedExpenses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$fixedExpenseStateImpl &&
            const DeepCollectionEquality()
                .equals(other._fixedExpenses, _fixedExpenses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_fixedExpenses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$fixedExpenseStateImplCopyWith<_$fixedExpenseStateImpl> get copyWith =>
      __$$fixedExpenseStateImplCopyWithImpl<_$fixedExpenseStateImpl>(
          this, _$identity);
}

abstract class _fixedExpenseState implements fixedExpenseState {
  const factory _fixedExpenseState({final List<FixedExpense> fixedExpenses}) =
      _$fixedExpenseStateImpl;

  @override
  List<FixedExpense> get fixedExpenses;
  @override
  @JsonKey(ignore: true)
  _$$fixedExpenseStateImplCopyWith<_$fixedExpenseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
