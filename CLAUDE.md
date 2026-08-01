# 家計簿アプリLife

ライフゲージで管理する家計簿アプリ。支出と収入を色分けされたゲージで視覚的に管理できる。

## コンセプト

**ライフゲージ**で残高状況を直感的に把握：
- 残高が十分 → 緑色
- 残高が半分 → 黄色
- 残高が少ない → 赤色

ゲームのHPゲージのように、お金の状況を一目で理解できる。

## プロジェクト情報

- **アプリ名**: 家計簿アプリLife
- **デベロッパ**: keito isobe
- **言語**: Dart / Flutter
- **バージョン**: 1.0.3+1
- **Dart SDK**: >=3.0.6 <4.0.0
- **対応**: iOS 12.0以降（iPhone, iPad, iPod touch）
- **App Store**: https://apps.apple.com/jp/app/id6457262696

## ビルドコマンド

```bash
# 依存関係インストール
flutter pub get

# コード生成（Freezed, json_serializable）
flutter pub run build_runner build

# 開発実行
flutter run

# iOS リリースビルド
flutter build ios --release

# Android リリースビルド
flutter build apk --release

# 静的解析
flutter analyze

# テスト
flutter test
```

## アーキテクチャ

**MVVM + リポジトリパターン + Riverpod**

```
UI (Pages/Widgets)
    ↓
Riverpod Providers
    ↓
ViewModels (StateNotifier)
    ↓
Repositories
    ↓
Databases (SQLite / Firebase)
```

## ディレクトリ構造

```
lib/
├── main.dart                 # エントリーポイント
├── background/               # バックグラウンド処理
├── datebases/                # SQLiteデータベース層
├── firebase_auth/            # Firebase認証
├── model/                    # データモデル（Freezed）
├── notifications/            # ローカル通知
├── page/                     # UIページ
│   ├── home/                 # ホーム画面
│   ├── input/                # 入力画面
│   ├── list/                 # リスト表示
│   ├── chart/                # グラフ・分析
│   ├── setting/              # 設定
│   ├── expense/              # 支出管理
│   ├── income/               # 収入管理
│   ├── category/             # カテゴリ設定
│   ├── fixed_expense/        # 固定支出
│   ├── recurring_income/     # 定期収入
│   ├── balance_saving/       # 残高・貯金設定
│   └── passcode/             # パスコードロック
├── provider/                 # Riverpodプロバイダ
├── repositorys/              # リポジトリ層
├── states/                   # 状態クラス（Freezed）
├── viewModels/               # StateNotifier
├── widgets/                  # 再利用可能UIコンポーネント
└── utils/                    # ユーティリティ
```

## 主要パッケージ

- **状態管理**: Riverpod, Freezed, Flutter Hooks
- **データベース**: sqflite (SQLite), Firebase Realtime Database, Cloud Firestore
- **認証**: Firebase Auth, Local Auth (生体認証)
- **UI**: Flutter ScreenUtil, Flutter Slidable, Grouped List
- **グラフ**: Pie Chart, Graphic
- **通知**: Flutter Local Notifications
- **広告**: Google Mobile Ads

## 主要機能

### ライフゲージ機能
設定金額の状況をゲージで表示。半分になると黄色、残少で赤くなり、支出管理を一目で把握できる。

### 支出・収入管理
- 支出・収入の記録と編集
- カテゴリ別に分類して管理
- リスト表示で履歴確認

### 自動入力機能
- 固定支出（家賃、サブスク等）を設定日時に自動入力
- 定期収入（給与等）を設定日時に自動入力
- 手動入力の手間を削減

### 分析機能
- グラフでカテゴリ別の支出・収入を可視化
- 月別の推移を確認

### セキュリティ機能
- パスコードロック（4桁）
- 生体認証（Face ID / Touch ID）対応

### クラウド同期
- Firebase連携で複数端末間のデータ同期
- アカウント登録でバックアップ

### 通知機能
- ローカル通知で入力忘れを防止

## 注意事項

- コード生成を使用しているため、model変更後は `flutter pub run build_runner build` を実行
- ディレクトリ名に一部typoあり（datebases, repositorys など）
