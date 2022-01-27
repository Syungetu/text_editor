# ローカル通知できるテキストエディター

簡単なメモアプリに通機能を組み合わせたFlutterアプリです。
解説用にシンプルな作りにしています。

## 簡単な解説

ディレクトリ構成
lib/page/
ページ（シーン）の処理を格納しています。
TitlePage()やMemoPage()など

lib/common/
アプリ全体に使用する処理を格納しています。
LocalNotifications()「ローカル通知」など

lib/main.dart
初期状態で生成されるメインプログラムです。
homeアプリ起動時に表示したいページを登録します。
このプロジェクトではTitlePage()を登録しています。
main()関数のrunApp(const MyApp());の後にローカル通知の初期化を行っています。

lib
