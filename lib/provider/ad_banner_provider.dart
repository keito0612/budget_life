import 'package:budget/states/ad_banner_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final adBannerProvider =
    StateNotifierProvider.autoDispose<AdBannerNotifier, AdBannerState>(
        (ref) => AdBannerNotifier());

class AdBannerNotifier extends StateNotifier<AdBannerState> {
  AdBannerNotifier() : super(const AdBannerState()) {
    loadAdBanner();
  }
  BannerAd? bannerAd;

  void loadAdBanner() {
    bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          state = state.copyWith(
            bannerAd: ad as BannerAd,
            isLoaded: true,
          );
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
          state.bannerAd?.dispose();
        },
      ),
    )..load();
  }

  String get _bannerAdUnitId {
    if (kDebugMode) {
      return dotenv.env['BANNER_AD_UNIT_ID_DEBUG'] ?? '';
    } else {
      return dotenv.env['BANNER_AD_UNIT_ID_PROD'] ?? '';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (state.bannerAd != null) {
      state.bannerAd?.dispose();
      state = state.copyWith(bannerAd: null);
    }
    super.dispose();
  }
}
