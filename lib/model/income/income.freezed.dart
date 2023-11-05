// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Income _$IncomeFromJson(Map<String, dynamic> json) {
  return _Income.fromJson(json);
}

/// @nodoc
mixin _$Income {
  int? get id => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int? get icon => throw _privateConstructorUsedError;
  int? get color => throw _privateConstructorUsedError;
  int? get categoryIndex => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $IncomeCopyWith<Income> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomeCopyWith<$Res> {
  factory $IncomeCopyWith(Income value, $Res Function(Income) then) =
      _$IncomeCopyWithImpl<$Res, Income>;
  @useResult
  $Res call(
      {int? id,
      String amount,
      String date,
      String memo,
      String? category,
      int? icon,
      int? color,
      int? categoryIndex});
}

/// @nodoc
class _$IncomeCopyWithImpl<$Res, $Val extends Income>
    implements $IncomeCopyWith<$Res> {
  _$IncomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? amount = null,
    Object? date = null,
    Object? memo = null,
    Object? category = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? categoryIndex = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as int?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryIndex: freezed == categoryIndex
          ? _value.categoryIndex
          : categoryIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IncomeImplCopyWith<$Res> implements $IncomeCopyWith<$Res> {
  factory _$$IncomeImplCopyWith(
          _$IncomeImpl value, $Res Function(_$IncomeImpl) then) =
      __$$IncomeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String amount,
      String date,
      String memo,
      String? category,
      int? icon,
      int? color,
      int? categoryIndex});
}

/// @nodoc
class __$$IncomeImplCopyWithImpl<$Res>
    extends _$IncomeCopyWithImpl<$Res, _$IncomeImpl>
    implements _$$IncomeImplCopyWith<$Res> {
  __$$IncomeImplCopyWithImpl(
      _$IncomeImpl _value, $Res Function(_$IncomeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? amount = null,
    Object? date = null,
    Object? memo = null,
    Object? category = freezed,
    Object? icon = freezed,
    Object? color = freezed,
    Object? categoryIndex = freezed,
  }) {
    return _then(_$IncomeImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as int?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryIndex: freezed == categoryIndex
          ? _value.categoryIndex
          : categoryIndex // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IncomeImpl with DiagnosticableTreeMixin implements _Income {
  const _$IncomeImpl(
      {this.id,
      this.amount = "",
      this.date = "",
      this.memo = "",
      this.category,
      this.icon,
      this.color,
      this.categoryIndex});

  factory _$IncomeImpl.fromJson(Map<String, dynamic> json) =>
      _$$IncomeImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey()
  final String amount;
  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final String memo;
  @override
  final String? category;
  @override
  final int? icon;
  @override
  final int? color;
  @override
  final int? categoryIndex;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Income(id: $id, amount: $amount, date: $date, memo: $memo, category: $category, icon: $icon, color: $color, categoryIndex: $categoryIndex)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Income'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('amount', amount))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('memo', memo))
      ..add(DiagnosticsProperty('category', category))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('categoryIndex', categoryIndex));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.categoryIndex, categoryIndex) ||
                other.categoryIndex == categoryIndex));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, amount, date, memo, category,
      icon, color, categoryIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomeImplCopyWith<_$IncomeImpl> get copyWith =>
      __$$IncomeImplCopyWithImpl<_$IncomeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IncomeImplToJson(
      this,
    );
  }
}

abstract class _Income implements Income {
  const factory _Income(
      {final int? id,
      final String amount,
      final String date,
      final String memo,
      final String? category,
      final int? icon,
      final int? color,
      final int? categoryIndex}) = _$IncomeImpl;

  factory _Income.fromJson(Map<String, dynamic> json) = _$IncomeImpl.fromJson;

  @override
  int? get id;
  @override
  String get amount;
  @override
  String get date;
  @override
  String get memo;
  @override
  String? get category;
  @override
  int? get icon;
  @override
  int? get color;
  @override
  int? get categoryIndex;
  @override
  @JsonKey(ignore: true)
  _$$IncomeImplCopyWith<_$IncomeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
