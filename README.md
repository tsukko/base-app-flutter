# flutter_app123

Flutterのビルド構成を自分なりのまとめるために作ったプロジェクト  
Dartのコードは前に作ったバーコード読取りアプリから適当に持ってきて、トップ画面が開くまでしか確認していないです。  
アプリとして正常に動作しないと思われます。

## 動作環境
- Android Studio 3.6
- Flutter 1.12.13

- Windows10、macOS Catalina(10.15)で動く想定

## Run/Debug Configurations
- debug-development
- release-staging
- release-production

## Android
- buildTypes
  - release
  - debug
- productFlavors
  - development　
  - staging
  - production
 
## iOS
- Debug (debug-development)
- Staging (release-staging)
- Production (release-production)
 
# TODO
- FirebaseのKeyファイルの扱い
- Proguard-rules
- 謎の調査
  - iOSでcamera: ^0.5.7+3パッケージがたまにおかしくなる（{FLUTTER_SDK_PATH}/.pub-cache配下のcameraパッケージを削除したり、git cloneし直したり）
  - iOSでビルドが遅い（camera、firebse系パッケージがあると特に。初回ビルド30分ぐらい？2回目以降も10分以上）
