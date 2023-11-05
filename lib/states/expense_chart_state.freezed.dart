// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_chart_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExpenseChartState {
  Map<String, Map<String, double>> get expense =>
      throw _privateConstructorUsedError;
  Map<String, List<int>> get colorList => throw _privateConstructorUsedError;
  Map<String, List<int>> get iconList => throw _privateConstructorUsedError;
  Map<String, int> get totalAmount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpenseChartStateCopyWith<ExpenseChartState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseChartStateCopyWith<$Res> {
  factory $ExpenseChartStateCopyWith(
          ExpenseChartState value, $Res Function(ExpenseChartState) then) =
      _$ExpenseChartStateCopyWithImpl<$Res, ExpenseChartState>;
  @useResult
  $Res call(
      {Map<String, Map<String, double>> expense,
      Map<String, List<int>> colorList,
      Map<String, List<int>> iconList,
      Map<String, int> totalAmount});
}

/// @nodoc
class _$ExpenseChartStateCopyWithImpl<$Res, $Val extends ExpenseChartState>
    implements $ExpenseChartStateCopyWith<$Res> {
  _$ExpenseChartStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expense = null,
    Object? colorList = null,
    Object? iconList = null,
    Object? totalAmount = null,
  }) {
    return _then(_value.copyWith(
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, double>>,
      colorList: null == colorList
          ? _value.colorList
          : colorList // ignore: cast_nullable_to_non_nullable
              as Map<String, List<int>>,
      iconList: null == iconList
          ? _value.iconList
          : iconList // ignore: cast_nullable_to_non_nullable
              as Map<String, List<int>>,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseChartStateImplCopyWith<$Res>
    implements $ExpenseChartStateCopyWith<$Res> {
  factory _$$ExpenseChartStateImplCopyWith(_$ExpenseChartStateImpl value,
          $Res Function(_$ExpenseChartStateImpl) then) =
      __$$ExpenseChartStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, Map<String, double>> expense,
      Map<String, List<int>> colorList,
      Map<String, List<int>> iconList,
      Map<String, int> totalAmount});
}

/// @nodoc
class __$$ExpenseChartStateImplCopyWithImpl<$Res>
    extends _$ExpenseChartStateCopyWithImpl<$Res, _$ExpenseChartStateImpl>
    implements _$$ExpenseChartStateImplCopyWith<$Res> {
  __$$ExpenseChartStateImplCopyWithImpl(_$ExpenseChartStateImpl _value,
      $Res Function(_$ExpenseChartStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expense = null,
    Object? colorList = null,
    Object? iconList = null,
    Object? totalAmount = null,
  }) {
    return _then(_$ExpenseChartStateImpl(
      expense: null == expense
          ? _value._expense
          : expense // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, double>>,
      colorList: null == colorList
          ? _value._colorList
          : colorList // ignore: cast_nullable_to_non_nullable
              as Map<String, List<int>>,
      iconList: null == iconList
          ? _value._iconList
          : iconList // ignore: cast_nullable_to_non_nullable
              as Map<String, List<int>>,
      totalAmount: null == totalAmount
          ? _value._totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc

class _$ExpenseChartStateImpl implements _ExpenseChartState {
  const _$ExpenseChartStateImpl(
      {final Map<String, Map<String, double>> expense = const {},
      final Map<String, List<int>> colorList = const {},
      final Map<String, List<int>> iconList = const {},
      final Map<String, int> totalAmount = const {}})
      : _expense = expense,
        _colorList = colorList,
        _iconList = iconList,
        _totalAmount = totalAmount;

  final Map<String, Map<String, double>> _expense;
  @override
  @JsonKey()
  Map<String, Map<String, double>> get expense {
    if (_expense is EqualUnmodifiableMapView) return _expense;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_expense);
  }

  final Map<String, List<int>> _colorList;
  @override
  @JsonKey()
  Map<String, List<int>> get colorList {
    if (_colorList is EqualUnmodifiableMapView) return _colorList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_colorList);
  }

  final Map<String, List<int>> _iconList;
  @override
  @JsonKey()
  Map<String, List<int>> get iconList {
    if (_iconList is EqualUnmodifiableMapView) return _iconList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_iconList);
  }

  final Map<String, int> _totalAmount;
  @override
  @JsonKey()
  Map<String, int> get totalAmount {
    if (_totalAmount is EqualUnmodifiableMapView) return _totalAmount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_totalAmount);
  }

  @override
  String toString() {
    return 'ExpenseChartState(expense: $expense, colorList: $colorList, iconList: $iconList, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseChartStateImpl &&
            const DeepCollectionEquality().equals(other._expense, _expense) &&
            const DeepCollectionEquality()
                .equals(other._colorList, _colorList) &&
            const DeepCollectionEquality().equals(other._iconList, _iconList) &&
            const DeepCollectionEquality()
                .equals(other._totalAmount, _totalAmount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_expense),
      const DeepCollectionEquality().hash(_colorList),
      const DeepCollectionEquality().hash(_iconList),
      const DeepCollectionEquality().hash(_totalAmount));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseChartStateImplCopyWith<_$ExpenseChartStateImpl> get copyWith =>
      __$$ExpenseChartStateImplCopyWithImpl<_$ExpenseChartStateImpl>(
          this, _$identity);
}

abstract class _ExpenseChartState implements ExpenseChartState {
  const factory _ExpenseChartState(
      {final Map<String, Map<String, double>> expense,
      final Map<String, List<int>> colorList,
      final Map<String, List<int>> iconList,
      final Map<String, int> totalAmount}) = _$ExpenseChartStateImpl;

  @override
  Map<String, Map<String, double>> get expense;
  @override
  Map<String, List<int>> get colorList;
  @override
  Map<String, List<int>> get iconList;
  @override
  Map<String, int> get totalAmount;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseChartStateImplCopyWith<_$ExpenseChartStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
