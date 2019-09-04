# 6. レシピ一覧のページネーション

レシピ一覧画面、実は今のままだと最新の20件しか表示できません。  
ユーザーが、20件目のレシピまでスクロールしたあとに、追加でもう20件読み込んで、リストに追加していく処理を実装していきましょう。

## ヒント
いくつか実装のヒントを書いていきます。

### UITableViewで、下までスクロールをしたのを検知する

下までスクロールしたかを判定するには、以下の`UIScrollView`のdelegateメソッドを実装します。  
`UITableView`は、`UIScrollView`のサブクラスで、`UITableView.delegate`は、`UIScrollView.delegate`の処理を継承しています。  


```swift
extension RecipesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 高さと、現在位置(offset)と、TableView(ScrollView)の中身の高さを使って判定する
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height, hasNext {
            // 下までスクロールしたので、次のページ読み込みをリクエストする
        }
    }
}
```


### 現在のページ数を元に、次のページを読み込む

既に、`RecipesViewModel`のinputで、`fetchRecipes(page:)`と、ページ数を投げられるようになっているので、所望のpageを引数に与えて取得します。  

ただ、`UITableViewで、下までスクロールをしたのを検知する` で検知したイベントが、短時間に何度か流れてくる可能性があるため、`isRequesting`というBool型の変数を用意して次のように制御すると良いでしょう。  
(あくまで簡易的な方法なので、他にもよいアプローチがあればそれを導入するのはありです。)

```swift
var isRequesting: Bool = false

func fetchRecipes(page: Int) {
    if isRequesting {
        return
    }
    isRequesting = true
    APIClient.getRecipes(page: page) { [weak self] result in
        guard let self = self else { return }
        // ... 通信結果をハンドリングする部分
        self.isRequsting = false
    }
}
```
