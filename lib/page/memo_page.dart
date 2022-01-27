import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../common/local_notifications.dart';

/// メモページのウィジェット（動的）
class MemoPage extends StatefulWidget {
  /// コンストラクタ
  @override
  MemoPage({Key? key}) : super(key: key) {}

  @override
  _memoPageState createState() => _memoPageState();
}

class _memoPageState extends State<MemoPage> {
  // タイトルインプットテキストコントローラー
  TextEditingController titleTextEditingController = TextEditingController();
  // 内容インプットテキストコントローラー
  TextEditingController contentsTextEditingController = TextEditingController();

  // ローカル通知の初期化
  LocalNotifications localNotifications = new LocalNotifications();

  // 選択されている日付
  DateTime? selectDateTime = null;

  /// 初期化処理
  @override
  void initState() {
    super.initState();

    titleTextEditingController.addListener(() {
      print(titleTextEditingController.text);
    });
    contentsTextEditingController.addListener(() {
      print(contentsTextEditingController.text);
    });
  }

  /// 削除処理
  @override
  void dispose() {
    super.dispose();
  }

  /// ウィジェット生成
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ヘッダーバーを消す
      appBar: AppBar(
        title: Text("メモ編集"),
        // 右のボタンを追加する
        actions: [
          // 通知のためのボタンを追加する
          IconButton(
            onPressed: () async {
              // シートを表示する
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SetNotificationSheetWidget(context);
                },
              );
            },
            icon: Icon(Icons.timer),
          ),
        ],
      ),
      // データの読み込み前と後でウィジェットを変化させる
      body: FutureBuilder(
        future: GetInitData(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            // ロードが終わっていない
            return Container(
              width: double.infinity, // 横幅を端末サイズに合わせる
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  child: Text("データ読込中"),
                ),
              ]),
            );
          }
          // UIを作成する
          return SingleChildScrollView(
            child: Container(
              width: double.infinity, // 横幅を端末サイズに合わせる
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      right: 10,
                      left: 10,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: 20,
                        left: 20,
                      ),
                      child: TextField(
                        enabled: true,
                        maxLines: 1,
                        controller: titleTextEditingController,
                        decoration: InputDecoration(
                          hintText: "10文字程度でわかりやすい文章にしてください",
                          labelText: "タイトル",
                        ),
                        onChanged: (text) {
                          // 入力されたテキストが変わった場合
                          print(text);
                        },
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      right: 10,
                      left: 10,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        right: 20,
                        left: 20,
                      ),
                      child: TextField(
                        enabled: true,
                        minLines: 10, // 10行分かけるようにする
                        maxLines: null,
                        textAlign: TextAlign.start,
                        controller: contentsTextEditingController,
                        decoration: InputDecoration(
                          hintText: "詳細な事柄を書いてください",
                          labelText: "内容",
                        ),
                        onChanged: (text) {
                          // 入力されたテキストが変わった場合
                          print(text);
                        },
                      ),
                    ),
                  ),
                  // 保存ボタン
                  Container(
                    // 外側の余白
                    margin: EdgeInsets.only(
                      top: 50,
                      bottom: 0,
                    ),
                    width: 300,
                    height: 50,
                    child: OutlinedButton(
                      child: Text(
                        "保存",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          // インスタンス取得
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          // 保存する
                          prefs.setString(
                              'title', titleTextEditingController.text);
                          prefs.setString(
                              'contents', contentsTextEditingController.text);

                          // 保存できたことをトースト表示する
                          Fluttertoast.showToast(msg: "本体に保存しました！");
                        } catch (e) {
                          // 何らかの原因で保存できなかった
                          Fluttertoast.showToast(msg: "保存に失敗しました……");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 端末に保存されているデータを取得する
  Future<bool> GetInitData() async {
    try {
      // インスタンス取得
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? titleText = prefs.getString('title');
      if (titleText != null) {
        titleTextEditingController.text = titleText;
      }

      String? contentsText = prefs.getString('contents');
      if (contentsText != null) {
        contentsTextEditingController.text = contentsText;
      }

      return true;
    } catch (e) {}

    // データの読み込みに失敗した
    return false;
  }

  /// 通知設定を行うシート
  Widget SetNotificationSheetWidget(BuildContext context) {
    // シートを動的に更新したいのでStatefulBuilderでラップする
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setSheetState) {
      return Container(
          child: Column(
        children: [
          // タイトル
          Container(
            // 外側の余白
            margin: EdgeInsets.only(
              top: 25,
              bottom: 10,
            ),
            child: Text(
              "通知設定",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          // 罫線
          Divider(
            color: Colors.grey,
          ),
          // タイトル
          Container(
            // 外側の余白
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "通知を行いたい日付と時間を設定します。\n過去の日付は無効になります。",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // 選択されている日付設定
          Container(
            // 外側の余白
            margin: EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Text(
              "通知日付：" +
                  (selectDateTime != null ? selectDateTime.toString() : "設定無し"),
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // 日付設定ピッカー
          Container(
            // 外側の余白
            margin: EdgeInsets.only(
              top: 0,
              bottom: 0,
            ),
            width: 200,
            height: 50,
            child: OutlinedButton(
              child: Text(
                "通知日付設定",
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              onPressed: () async {
                // 通知日付設定を行う
                await DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  locale: LocaleType.jp,
                  currentTime: DateTime.now(),
                  // ピッカーを動かしたときに呼ばれる
                  onChanged: (time) {},
                  // 日付設定が完了したときに呼ばれる
                  onConfirm: (time) {
                    setSheetState(() {
                      selectDateTime = time;
                    });
                  },
                );
              },
            ),
          ),
          // 設定ボタン
          Container(
            // 外側の余白
            margin: EdgeInsets.only(
              top: 80,
              bottom: 0,
            ),
            width: 350,
            height: 70,
            child: OutlinedButton(
              child: Text(
                "設定完了",
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              onPressed: () async {
                // 通知設定を行う
                if (selectDateTime == null) {
                  return;
                }
                // 通知設定
                bool isCompleted =
                    await localNotifications.SetLocalNotification(
                        titleTextEditingController.text,
                        contentsTextEditingController.text,
                        selectDateTime!);
                if (isCompleted == true) {
                  Fluttertoast.showToast(msg: "通知の設定に成功しました！");
                } else {
                  Fluttertoast.showToast(msg: "通知の設定に失敗しました……");
                }
              },
            ),
          ),
          // コメント
          Container(
            // 外側の余白
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Text(
              "設定した日付に通知を行います。\nアプリを閉じていても通知は届きます。",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ));
    });
  }
}
