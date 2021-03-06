# 9. さらなる改善へ

え、ここまで進んだんですか！！！？？？  
さらなる改善として、以下自由に取り組んでみましょう。  
ここに載っている以外の課題を自分で見つけて取り組むのもokです。


## レシピ一覧画面にリフレッシュの仕組みを入れる(引っ張って更新)

現在のレシピ一覧画面だと、追加読み込みはできるものの再度リストをリフレッシュして`page=1`から表示しなおすことができなくなっています。  
`UIRefreshControl`と呼ばれるUIパーツを活用して、画面を引っ張ったときに、`page=1`で再リクエストしてリフレッシュできるようにしてみましょう。

## レシピ一覧画面にもお気に入りボタンを出し、お気に入りの追加/削除ができるようにする

発展課題の7をやることで、レシピ詳細画面にてお気に入りを付けたり外したりができるようになります。  
今度は、レシピ一覧画面のセルにお気に入りボタンを表示して、一覧画面からもお気に入りに追加したり削除したりできるようにしてみましょう。

## UIに載せる情報を増やす/UIをもっと改良してみる

GraphQLのリクエストを投げて返ってくる情報を増やし、それをUIに反映したり、見た目をもっとブラッシュアップしてみましょう。  
例えば、レシピ詳細画面で叩く`recipe`クエリで、`steps`が取得できるので、それを取得して、手順を表示してみるのもいいでしょう。

## レシピの閲覧履歴機能を実装する

レシピ詳細画面に遷移したのを記録し、それを閲覧履歴として実装してみましょう。  
自分がみたレシピの履歴は、次のようなDBに保存するのが良いでしょう

- UserDefaults
- CoreData
- Realm(外部ライブラリ)
- Firebase(Cloud Firestore)

保存するDBはどれでも構いません。一番簡単なのがUserDefaultsに、閲覧したレシピのIDを保存していくのが簡単だと思います。  

## レシピをWebViewで見れるようにする

今回のアプリケーションでは、レシピ詳細画面で見れる情報が限られているので、本家のクックパッドを、WebViewで開けるようにしてみましょう。  
WebViewは、`SFSafariViewController`を使うと簡単に実装できます。開くページは、`https://cookpad.com/recipe/[recipe_id]`というURLで開くことができます。

## AuthoCenterのtokenが失効した場合の処理

現状は、一度AuthoCenterに`id_token`を発行してもらったあと、それを使い回すようにしています。  
本来は、`konmai=true`のパラメータを付けないと、`id_token`は120秒で失効してしまうので、一度取得したら使い回すのではなく、リクエスト時に都度問い合わせて取得する方式や、失効した場合に再度取得するように処理を変更してみましょう。


## RxSwiftを使ってViewModelを書き換える

今回はMVVMアーキテクチャで書いたのですが、やや古典的というかobserverパターンを用いてのMVVMアーキテクチャで設計しました。  
現在ではiOSアプリの開発では、MVVMアーキテクチャに依らず、`RxSwift`とよばれるFRP(関数型リアクティブプログラミング)フレームワークを使うことがデファクトスタンダードになってきています。  
(注: iOS13からはCombineというフレームワークが標準搭載されます)  
その`RxSwift`を使ってViewModel含め書き換えてみましょう

## UnitTestを書いてみる

ViewModelに関してはUnitTestが書けると思うので書いてみましょう。
モックデータ、スタブ、DI(Dependency Injection)など、色々手法を取り入れつつ、テストを書いてみましょう。  
