import 'dart:io';
import 'package:budget/states/reward_ad_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final rewardAdProvider = StateNotifierProvider<RewardAdNotifier, RewardAdState>(
    (ref) => RewardAdNotifier());

class RewardAdNotifier extends StateNotifier<RewardAdState> {
  RewardAdNotifier() : super(const RewardAdState()) {
    loadRewardAd();
  }

  Future loadRewardAd() async {
    await RewardedAd.load(
      adUnitId: _rewardAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          state = state.copyWith(
            rewardedAd: ad,
            isLoaded: true,
          );
          state.rewardedAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) =>
                print('$ad onAdShowedFullScreenContent.'),
            onAdDismissedFullScreenContent: (RewardedAd ad) async {
              print('$ad onAdDismissedFullScreenContent.');
              ad.dispose();
              state.rewardedAd?.dispose;
              await loadRewardAd();
            },
            onAdFailedToShowFullScreenContent:
                (RewardedAd ad, AdError error) async {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              state.rewardedAd?.dispose;
              await loadRewardAd();
            },
            onAdImpression: (RewardedAd ad) =>
                print('$ad impression occurred.'),
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          state = state.copyWith(isLoaded: false);
        },
      ),
    );
  }

  /// 引数は報酬を付与する処理
  Future<void> showRewardAd(VoidCallback callback) async {
    await state.rewardedAd?.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        callback(); // リワードの視聴を完了した場合の報酬付与処理を呼び出す
      },
    );
  }

  String get _rewardAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    if (Platform.isIOS) {
      return 'ca-app-pub-8369847853540237/8608048258';
    } else {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
  }
}
