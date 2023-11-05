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
abstract class _$$CategoryExpenseStateImplCopyWith<$Res>
    implements $CategoryExpenseStateCopyWith<$Res> {
  factory _$$CategoryExpenseStateImplCopyWith(_$CategoryExpenseStateImpl value,
          $Res Function(_$CategoryExpenseStateImpl) then) =
      __$$CategoryExpenseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Category> categorys});
}

/// @nodoc
class __$$CategoryExpenseStateImplCopyWithImpl<$Res>
    extends _$CategoryExpenseStateCopyWithImpl<$Res, _$CategoryExpenseStateImpl>
    implements _$$CategoryExpenseStateImplCopyWith<$Res> {
  __$$CategoryExpenseStateImplCopyWithImpl(_$CategoryExpenseStateImpl _value,
      $Res Function(_$CategoryExpenseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categorys = null,
  }) {
    return _then(_$CategoryExpenseStateImpl(
      categorys: null == categorys
          ? _value._categorys
          : categorys // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _$CategoryExpenseStateImpl implements _CategoryExpenseState {
  const _$CategoryExpenseStateImpl({final List<Category> categorys = const []})
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
            other is _$CategoryExpenseStateImpl &&
            const DeepCollectionEquality()
                .equals(other._categorys, _categorys));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_categorys));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryExpenseStateImplCopyWith<_$CategoryExpenseStateImpl>
      get copyWith =>
          __$$CategoryExpenseStateImplCopyWithImpl<_$CategoryExpenseStateImpl>(
              this, _$identity);
}

abstract class _CategoryExpenseState implements CategoryExpenseState {
  const factory _CategoryExpenseState({final List<Category> categorys}) =
      _$CategoryExpenseStateImpl;

  @override
  List<Category> get categorys;
  @override
  @JsonKey(ignore: true)
  _$$CategoryExpenseStateImplCopyWith<_$CategoryExpenseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
