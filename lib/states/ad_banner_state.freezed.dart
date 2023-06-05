// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_banner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AdBannerState {
  BannerAd? get bannerAd => throw _privateConstructorUsedError;
  bool get isLoaded => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AdBannerStateCopyWith<AdBannerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdBannerStateCopyWith<$Res> {
  factory $AdBannerStateCopyWith(
          AdBannerState value, $Res Function(AdBannerState) then) =
      _$AdBannerStateCopyWithImpl<$Res, AdBannerState>;
  @useResult
  $Res call({BannerAd? bannerAd, bool isLoaded});
}

/// @nodoc
class _$AdBannerStateCopyWithImpl<$Res, $Val extends AdBannerState>
    implements $AdBannerStateCopyWith<$Res> {
  _$AdBannerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bannerAd = freezed,
    Object? isLoaded = null,
  }) {
    return _then(_value.copyWith(
      bannerAd: freezed == bannerAd
          ? _value.bannerAd
          : bannerAd // ignore: cast_nullable_to_non_nullable
              as BannerAd?,
      isLoaded: null == isLoaded
          ? _value.isLoaded
          : isLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AdBannerStateCopyWith<$Res>
    implements $AdBannerStateCopyWith<$Res> {
  factory _$$_AdBannerStateCopyWith(
          _$_AdBannerState value, $Res Function(_$_AdBannerState) then) =
      __$$_AdBannerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({BannerAd? bannerAd, bool isLoaded});
}

/// @nodoc
class __$$_AdBannerStateCopyWithImpl<$Res>
    extends _$AdBannerStateCopyWithImpl<$Res, _$_AdBannerState>
    implements _$$_AdBannerStateCopyWith<$Res> {
  __$$_AdBannerStateCopyWithImpl(
      _$_AdBannerState _value, $Res Function(_$_AdBannerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bannerAd = freezed,
    Object? isLoaded = null,
  }) {
    return _then(_$_AdBannerState(
      bannerAd: freezed == bannerAd
          ? _value.bannerAd
          : bannerAd // ignore: cast_nullable_to_non_nullable
              as BannerAd?,
      isLoaded: null == isLoaded
          ? _value.isLoaded
          : isLoaded // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AdBannerState implements _AdBannerState {
  const _$_AdBannerState({this.bannerAd, this.isLoaded = false});

  @override
  final BannerAd? bannerAd;
  @override
  @JsonKey()
  final bool isLoaded;

  @override
  String toString() {
    return 'AdBannerState(bannerAd: $bannerAd, isLoaded: $isLoaded)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AdBannerState &&
            (identical(other.bannerAd, bannerAd) ||
                other.bannerAd == bannerAd) &&
            (identical(other.isLoaded, isLoaded) ||
                other.isLoaded == isLoaded));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bannerAd, isLoaded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AdBannerStateCopyWith<_$_AdBannerState> get copyWith =>
      __$$_AdBannerStateCopyWithImpl<_$_AdBannerState>(this, _$identity);
}

abstract class _AdBannerState implements AdBannerState {
  const factory _AdBannerState(
      {final BannerAd? bannerAd, final bool isLoaded}) = _$_AdBannerState;

  @override
  BannerAd? get bannerAd;
  @override
  bool get isLoaded;
  @override
  @JsonKey(ignore: true)
  _$$_AdBannerStateCopyWith<_$_AdBannerState> get copyWith =>
      throw _privateConstructorUsedError;
}
