# ローカル通知できるテキストエディター
簡単なメモアプリに通機能を組み合わせたFlutterアプリです。  
解説用にシンプルな作りにしています。  
 
## Dartについて
Dartは命名規則によって **Private** や **Public** 属性が付きます。  
また変数名に大文字を入れることを推奨していません。  
例） TitlePage → title_page  
 
変数名や関数名の先頭に **_（アンダースコア）** をいれると **Private属性** になります 。 
例） _title_page → Private属性  
例） title_page → public属性  
 
## 簡単な解説
- ディレクトリ構成
    - lib/page/
        - ページ（シーン）の処理を格納しています。
        -  'TitlePage()' や' MemoPage()' など

    - lib/common/
        - アプリ全体に使用する処理を格納しています。
        -  'LocalNotifications()' 「ローカル通知」など

    - lib/main.dart
        - 初期状態で生成されるメインプログラムです。
        - homeアプリ起動時に表示したいページを登録します。
        - このプロジェクトでは 'TitlePage()' を登録しています。
        - main()関数の 'runApp(const MyApp());' の後にローカル通知の初期化を行っています。

    - lib/page/title_page.dart
        - タイトルシーンを管理しています。
        - SNSなどのアカウントログインなどが必要な場合はココに登録する想定で作りました。
        - 今回は特にログイン処理とか無いので、 'MemoPage()' に遷移するページを用意してあるだけのページになります。

    - lib/page/memo_page.dart
        - メモ編集のメインシーンを管理しています。
        - 画面構成はタイトルテキスト編集用の 'TextField' と内容テキスト編集用の 'TextField' の2つを配置しているだけとなります。
        -  'AppBar' には通知設定用にボタンを一つ追加しています。
        - 通知設定には 'showModalBottomSheet' で実装して、時間設定はアセットの「flutter_datetime_picker」を利用しています。

## 使用アセット
- shared_preferences: ^2.0.12 
    - ローカル保存用アセット
- fluttertoast: ^8.0.8 
    - トースト
- intl: ^0.17.0 
    - 日付の表示周りの管理
- flutter_datetime_picker: ^1.5.1 
    - 日付ピッカーの表示
- flutter_local_notifications: ^9.2.0 
    - ローカル通知
- flutter_native_timezone: ^2.0.0 
    - タイムゾーン管理
