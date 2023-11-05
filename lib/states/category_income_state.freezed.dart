// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_income_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CategoryIncomeState {
  List<Category> get categoryIncomes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoryIncomeStateCopyWith<CategoryIncomeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryIncomeStateCopyWith<$Res> {
  factory $CategoryIncomeStateCopyWith(
          CategoryIncomeState value, $Res Function(CategoryIncomeState) then) =
      _$CategoryIncomeStateCopyWithImpl<$Res, CategoryIncomeState>;
  @useResult
  $Res call({List<Category> categoryIncomes});
}

/// @nodoc
class _$CategoryIncomeStateCopyWithImpl<$Res, $Val extends CategoryIncomeState>
    implements $CategoryIncomeStateCopyWith<$Res> {
  _$CategoryIncomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryIncomes = null,
  }) {
    return _then(_value.copyWith(
      categoryIncomes: null == categoryIncomes
          ? _value.categoryIncomes
          : categoryIncomes // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryIncomeStateImplCopyWith<$Res>
    implements $CategoryIncomeStateCopyWith<$Res> {
  factory _$$CategoryIncomeStateImplCopyWith(_$CategoryIncomeStateImpl value,
          $Res Function(_$CategoryIncomeStateImpl) then) =
      __$$CategoryIncomeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Category> categoryIncomes});
}

/// @nodoc
class __$$CategoryIncomeStateImplCopyWithImpl<$Res>
    extends _$CategoryIncomeStateCopyWithImpl<$Res, _$CategoryIncomeStateImpl>
    implements _$$CategoryIncomeStateImplCopyWith<$Res> {
  __$$CategoryIncomeStateImplCopyWithImpl(_$CategoryIncomeStateImpl _value,
      $Res Function(_$CategoryIncomeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryIncomes = null,
  }) {
    return _then(_$CategoryIncomeStateImpl(
      categoryIncomes: null == categoryIncomes
          ? _value._categoryIncomes
          : categoryIncomes // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _$CategoryIncomeStateImpl implements _CategoryIncomeState {
  const _$CategoryIncomeStateImpl(
      {final List<Category> categoryIncomes = const []})
      : _categoryIncomes = categoryIncomes;

  final List<Category> _categoryIncomes;
  @override
  @JsonKey()
  List<Category> get categoryIncomes {
    if (_categoryIncomes is EqualUnmodifiableListView) return _categoryIncomes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryIncomes);
  }

  @override
  String toString() {
    return 'CategoryIncomeState(categoryIncomes: $categoryIncomes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryIncomeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._categoryIncomes, _categoryIncomes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_categoryIncomes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryIncomeStateImplCopyWith<_$CategoryIncomeStateImpl> get copyWith =>
      __$$CategoryIncomeStateImplCopyWithImpl<_$CategoryIncomeStateImpl>(
          this, _$identity);
}

abstract class _CategoryIncomeState implements CategoryIncomeState {
  const factory _CategoryIncomeState({final List<Category> categoryIncomes}) =
      _$CategoryIncomeStateImpl;

  @override
  List<Category> get categoryIncomes;
  @override
  @JsonKey(ignore: true)
  _$$CategoryIncomeStateImplCopyWith<_$CategoryIncomeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
