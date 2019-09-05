# この講義の目的

- Androidアプリ開発の基本を一通り経験できる
  - サーバーからデータを取得する
  - UIを構築して、プログラムからデータと紐付ける
  - ユーザーの行動に応じて、処理を実行する
  - ある画面から別の画面に遷移する
- プロトタイピングや、簡単な動作を行うアプリを開発できるようになる

# 事前準備

- [事前準備](preparation)

# Androidアプリ開発について

スライドはこちら。
https://speakerdeck.com/litmon/cookpad-summer-internship-2019-day4-android

[今回使用する程度のKotlin言語機能はこちら](doc_kotlin_cheatsheet)

# ミニクックパッドを作る

- [第1章: Androidアプリをビルドする](chapter1)
  - プロジェクトを作成する
  - アプリをビルドして実行する
- [第2章: レシピ一覧を表示する](chapter2)
  - Fragmentを作成して表示する
  - リストの要素Viewを作成する
  - GraphQLでデータを読み込む
  - Viewとデータを結びつける
- [第3章: レシピ詳細に遷移する](chapter3)
  - Navigationによる画面遷移を行う
  - 画面遷移時に値を渡す
- [第4章: ボトムナビを導入する](chapter4)
  - 最近のアプリらしい形を導入する
  - Material ComponentのBottomNavを導入する

-- 休憩 --

- [第5章: お気に入り機能を実装する](chapter5)
  - レシピ一覧からお気に入りできるようにする
  - お気に入り一覧画面を作成する
  - レシピ詳細からお気に入りできるようにする

# 応用課題

以降は好きに改造しましょう。

- API日に作ったAPIを使える形にするのもよし、
- こちらで用意したシナリオをなぞるでもよし、
- まったく新しい機能を考えて導入するでもよし、

ここから先はあなたの想像力と実装力が試されます。
頑張りましょう。

## 後半の進め方

- 第5章: お気に入り機能を実装する までを完了させる
- 自由にアプリをカスタマイズする

## 用意した課題一覧

- [SNSにシェアする機能を実装する](advanced_sns_share)
  - intentを使って他アプリに情報を渡す
- [画像だけ見る機能を実装する](advanced_image)
  - SharedElementTransitionなどを使うと面白くできそう
- [レシピのURLを開くとアプリのレシピ詳細画面に遷移する](advanced_deeplink)
  - いわゆる、DeepLinkと呼ばれる機能
  - Navigationと組み合わせると比較的簡単に実装できる
- [ページングに対応する](advanced_paging)
  - リスト要素の一番最後に次読み込むための仕組みを導入する
  - GroupieのSection, Footerをうまく使うと簡単に実装できる
- [レシピの表示履歴機能を実装する](advanced_history)
  - アプリ上にデータを保存する, 保存したデータを取り出す(Room, SharedPreferences)
  - 閲覧履歴画面を作成する
- [ログイン機能を実装する](advanced_login)
  - 任意のユーザーにログインできる仕組みを用意する

# 困ったときに見る資料

- [Kotlin チートシート](doc_kotlin_cheatsheet)
- [Android レイアウトチートシート](doc_android_layout_cheatsheet)
- [Android Studio チートシート](doc_android_studio_cheatsheet)
