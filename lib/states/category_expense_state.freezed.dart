// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_expense_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CategoryExpenseState {
  List<Category> get categorys => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoryExpenseStateCopyWith<CategoryExpenseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryExpenseStateCopyWith<$Res> {
  factory $CategoryExpenseStateCopyWith(CategoryExpenseState value,
          $Res Function(CategoryExpenseState) then) =
      _$CategoryExpenseStateCopyWithImpl<$Res, CategoryExpenseState>;
  @useResult
  $Res call({List<Category> categorys});
}

/// @nodoc
class _$CategoryExpenseStateCopyWithImpl<$Res,
        $Val extends CategoryExpenseState>
    implements $CategoryExpenseStateCopyWith<$Res> {
  _$CategoryExpenseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categorys = null,
  }) {
    return _then(_value.copyWith(
      categorys: null == categorys
          ? _value.categorys
          : categorys // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CategoryExpenseStateCopyWith<$Res>
    implements $CategoryExpenseStateCopyWith<$Res> {
  factory _$$_CategoryExpenseStateCopyWith(_$_CategoryExpenseState value,
          $Res Function(_$_CategoryExpenseState) then) =
      __$$_CategoryExpenseStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Category> categorys});
}

/// @nodoc
class __$$_CategoryExpenseStateCopyWithImpl<$Res>
    extends _$CategoryExpenseStateCopyWithImpl<$Res, _$_CategoryExpenseState>
    implements _$$_CategoryExpenseStateCopyWith<$Res> {
  __$$_CategoryExpenseStateCopyWithImpl(_$_CategoryExpenseState _value,
      $Res Function(_$_CategoryExpenseState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categorys = null,
  }) {
    return _then(_$_CategoryExpenseState(
      categorys: null == categorys
          ? _value._categorys
          : categorys // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _$_CategoryExpenseState implements _CategoryExpenseState {
  const _$_CategoryExpenseState({final List<Category> categorys = const []})
      : _categorys = categorys;

  final List<Category> _categorys;
  @override
  @JsonKey()
  List<Category> get categorys {
    if (_categorys is EqualUnmodifiableListView) return _categorys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categorys);
  }

  @override
  String toString() {
    return 'CategoryExpenseState(categorys: $categorys)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CategoryExpenseState &&
            const DeepCollectionEquality()
                .equals(other._categorys, _categorys));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_categorys));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CategoryExpenseStateCopyWith<_$_CategoryExpenseState> get copyWith =>
      __$$_CategoryExpenseStateCopyWithImpl<_$_CategoryExpenseState>(
          this, _$identity);
}

abstract class _CategoryExpenseState implements CategoryExpenseState {
  const factory _CategoryExpenseState({final List<Category> categorys}) =
      _$_CategoryExpenseState;

  @override
  List<Category> get categorys;
  @override
  @JsonKey(ignore: true)
  _$$_CategoryExpenseStateCopyWith<_$_CategoryExpenseState> get copyWith =>
      throw _privateConstructorUsedError;
}
