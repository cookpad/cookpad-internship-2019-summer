# Setup

完全な状態のiOSのアプリケーションを動かす場合は、以下の通りセットアップすることでビルドして実行することができます

```sh
# Clone repository
$ git clone git@github.com:cookpad/cookpad-internship-2019-summer.git
# Change directory to project/ios
$ cd path/to/cookpad-internship-2019-summer/ios
$ make
```

## 注意点

インターン講義時点では、上記setupですぐに動かせる状態だったが、公開にあたりいくつか修正しないと動かせないので、以下の項目を確認しつつ、setupしてください。

- `package.json`、`APIClient.swift`の`[enter_your_endpoint]`を、自身で作成したGraphQLサーバーのエンドポイントに書き換える
- `AuthoCenterTokenRequest.swift`の`[enter_your_auth_center_endpoint]`を、自身で作成したAuthCenterのエンドポイントに置き換える
- 以下の画像をプロジェクトに追加してください。追加することで画像が表示されるようになります
  - `star_blank`: レシピにお気に入りを付けるボタン(isLiked=false)
  - `star_fill`: レシピにお気に入りを付けるボタン(isLiked=true)
  - `tab_star_blank`: お気に入り一覧のタブアイコン(非選択時)
  - `tab_star_fill`: お気に入り一覧のタブアイコン(選択時)
  - `tab_recipe`: レシピ一覧画面のタブアイコン