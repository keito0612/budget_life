// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_chart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExpenseChart {
  Map<String, double> get expense => throw _privateConstructorUsedError;
  List<int> get colorList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExpenseChartCopyWith<ExpenseChart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseChartCopyWith<$Res> {
  factory $ExpenseChartCopyWith(
          ExpenseChart value, $Res Function(ExpenseChart) then) =
      _$ExpenseChartCopyWithImpl<$Res, ExpenseChart>;
  @useResult
  $Res call({Map<String, double> expense, List<int> colorList});
}

/// @nodoc
class _$ExpenseChartCopyWithImpl<$Res, $Val extends ExpenseChart>
    implements $ExpenseChartCopyWith<$Res> {
  _$ExpenseChartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expense = null,
    Object? colorList = null,
  }) {
    return _then(_value.copyWith(
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      colorList: null == colorList
          ? _value.colorList
          : colorList // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseChartImplCopyWith<$Res>
    implements $ExpenseChartCopyWith<$Res> {
  factory _$$ExpenseChartImplCopyWith(
          _$ExpenseChartImpl value, $Res Function(_$ExpenseChartImpl) then) =
      __$$ExpenseChartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, double> expense, List<int> colorList});
}

/// @nodoc
class __$$ExpenseChartImplCopyWithImpl<$Res>
    extends _$ExpenseChartCopyWithImpl<$Res, _$ExpenseChartImpl>
    implements _$$ExpenseChartImplCopyWith<$Res> {
  __$$ExpenseChartImplCopyWithImpl(
      _$ExpenseChartImpl _value, $Res Function(_$ExpenseChartImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expense = null,
    Object? colorList = null,
  }) {
    return _then(_$ExpenseChartImpl(
      expense: null == expense
          ? _value._expense
          : expense // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      colorList: null == colorList
          ? _value._colorList
          : colorList // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$ExpenseChartImpl implements _ExpenseChart {
  const _$ExpenseChartImpl(
      {final Map<String, double> expense = const {},
      final List<int> colorList = const []})
      : _expense = expense,
        _colorList = colorList;

  final Map<String, double> _expense;
  @override
  @JsonKey()
  Map<String, double> get expense {
    if (_expense is EqualUnmodifiableMapView) return _expense;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_expense);
  }

  final List<int> _colorList;
  @override
  @JsonKey()
  List<int> get colorList {
    if (_colorList is EqualUnmodifiableListView) return _colorList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colorList);
  }

  @override
  String toString() {
    return 'ExpenseChart(expense: $expense, colorList: $colorList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseChartImpl &&
            const DeepCollectionEquality().equals(other._expense, _expense) &&
            const DeepCollectionEquality()
                .equals(other._colorList, _colorList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_expense),
      const DeepCollectionEquality().hash(_colorList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseChartImplCopyWith<_$ExpenseChartImpl> get copyWith =>
      __$$ExpenseChartImplCopyWithImpl<_$ExpenseChartImpl>(this, _$identity);
}

abstract class _ExpenseChart implements ExpenseChart {
  const factory _ExpenseChart(
      {final Map<String, double> expense,
      final List<int> colorList}) = _$ExpenseChartImpl;

  @override
  Map<String, double> get expense;
  @override
  List<int> get colorList;
  @override
  @JsonKey(ignore: true)
  _$$ExpenseChartImplCopyWith<_$ExpenseChartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
