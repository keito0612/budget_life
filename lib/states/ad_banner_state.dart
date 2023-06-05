import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
part 'ad_banner_state.freezed.dart';

@freezed
class AdBannerState with _$AdBannerState {
  const factory AdBannerState({
    BannerAd? bannerAd,
    @Default(false) bool isLoaded,
  }) = _AdBannerState;
}
