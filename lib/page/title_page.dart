import 'package:flutter/material.dart';

import 'memo_page.dart';

/// タイトルページのウィジェット（動的）
class TitlePage extends StatefulWidget {
  /// コンストラクタ
  @override
  TitlePage({Key? key}) : super(key: key) {}

  @override
  _titlePageState createState() => _titlePageState();
}

class _titlePageState extends State<TitlePage> {
  /// 初期化処理
  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      // コンテンツ内容
      body: Container(
        width: double.infinity, // 横幅を端末サイズに合わせる
        color: Colors.white,
        // 縦にウィジェットを配置する
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // タイトル
            Container(
              // 外側の余白
              margin: EdgeInsets.only(
                top: 300,
                bottom: 10,
              ),
              //// 内側の余白
              //padding: EdgeInsets.only(
              //  top: 300,
              //  bottom: 10,
              //),
              child: Column(
                children: [
                  // タイトルテキスト
                  Text(
                    "お知らせメモ帳",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 64,
                    ),
                  ),
                  // サブタイトルテキスト
                  Text(
                    "~ 通知してくれるメモ帳 ~",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            // スタートボタン
            Container(
              // 外側の余白
              margin: EdgeInsets.only(
                top: 0,
                bottom: 0,
              ),
              width: 300,
              height: 50,
              child: OutlinedButton(
                child: Text(
                  "スタート",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                onPressed: () async {
                  // メモページに移動する
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MemoPage()));
                },
              ),
            ),
            // 著作権表示
            Container(
              // 外側の余白
              margin: EdgeInsets.only(
                top: 0,
                bottom: 25,
              ),
              child: Text(
                "Copyright © 2021- すたじお・くろす！ All Rights Reserved.\nhttps://studio-cross.com",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
