# 4. 複雑なUIレイアウトとレシピ詳細画面

前章までで、レシピ一覧画面を作成することができたので、今度は一覧をタップしたときに詳細画面に遷移し、レシピ情報をより詳細に表示できるようにしましょう。  

<img src='../screenshots/readme_1.png' width=375 />

## RecipeViewControllerの作成と遷移
まずは、`MiniCookpad/Views/Recipe`ディレクトリを作り、その中に

- `RecipeViewController.swift`
- `RecipeViewController.storyboard`

を作成します。`storyboard`ファイルは「User Interface」の中にあります。

<img src='../screenshots/chapter_4_0.png' width=600 />

<img src='../screenshots/chapter_4_1.png' width=400 />

`RecipeViewController`には次のようにコードを追加しておきます。

```swift
import Instantiate
import InstantiateStandard
import UIKit

final class RecipeViewController: UIViewController, StoryboardInstantiatable {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var recipeIDLabel: UILabel!
    @IBOutlet private weak var ingredientsStackView: UIStackView!

    func inject(_ dependency: String) {
        print("recipeID", dependency)
    }
}
```

それぞれ、storyboardで構築したViewのパーツと接続するための変数の定義と、`StoryboardInstantiatable`を`RecipeViewController`に適合しておきます。これはStoryboardからViewControllerを生成する処理を手助けしてくれるものになります。

`RecipeViewController.storyboard`を開くと、何もない状態なので、`ViewController`を配置します。

<img src='../screenshots/chapter_4_2.png' width=600 />  

配置したら、

- ViewControllerの名前を`RecipeViewController`にする
- `Is Initial View Controller`にチェックを付ける

をします。

<img src='../screenshots/chapter_4_3.png' width=600 />  
<img src='../screenshots/chapter_4_4.png' width=600 />  

これで、storyboardから`RecipeViewController`を生成できるようになったので、`RecipesViewController`に変更を加え、作成した`RecipeViewController`にレシピIDを渡して生成し、画面遷移の実装をしましょう。

```swift
final class RecipesViewController: UIViewController {
    // 省略

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        viewModel.outputs.recipesFetched { [weak self] recipes, page in
            self?.recipes.append(contentsOf: recipes)
            self?.tableView.reloadData()
        }

        viewModel.inputs.fetchRecipes(page: 1)
    }
    
    // 省略

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecipeViewController.instantiate(with: recipes[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}
```

```diff
// diff
final class RecipesViewController: UIViewController {
    // 省略

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
+         tableView.delegate = self

        viewModel.outputs.recipesFetched { [weak self] recipes, page in
            self?.recipes.append(contentsOf: recipes)
            self?.tableView.reloadData()
        }

        viewModel.inputs.fetchRecipes(page: 1)
    }
    
    // 省略

+ extension RecipesViewController: UITableViewDelegate {
+     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
+         let vc = RecipeViewController.instantiate(with: recipes[indexPath.row].id)
+         navigationController?.pushViewController(vc, animated: true)
+     }
+ }
```

ここまでで、ビルドをして実行してみます。  
問題がなければ、一覧からレシピを選択すると、白い画面に遷移するようになっているはずです。  

<img src='../screenshots/chapter_4_23.png' width=600 />  

## RecipeViewControllerのUIを組む
ここが、今日の講義の中で一番の難所になります。  
次のような構成でViewControllerのUIを組みます。

<img src='../screenshots/chapter_4_5.png' width=600 />  

...???  

一つずつ説明していきます。  
まずはUIScrollViewを追加し、ViewにぴったりくっつくようにAutoLayoutの制約を追加します。  
UIScrollViewは、名前の通りでこのViewの中に配置するコンテンツの高さや幅が指定したサイズより大きくなったときに、スクロールすることができるViewになっています。  
レシピ詳細の場合、レシピ説明や材料が多かった場合に画面をはみでてしまう可能性がでてくるので、このUIScrollViewを活用します。

<img src='../screenshots/chapter_4_6.png' width=600 />  

次に、UIScrollViewの上にUIImageViewを配置し、

- UIImageViewの上端、左端、右端がUIScrollViewと重なる
- UIImageViewの横幅は、Viewと同じ横幅になる
- UIImageViewのアスペクト比は`375:250`になる

といった制約を追加します。少しむずかしいですね。下記の図を参考に組んでみます。  

<img src='../screenshots/chapter_4_7.png' width=600 />  
<img src='../screenshots/chapter_4_8.png' width=600 />  
<img src='../screenshots/chapter_4_9.png' width=600 />  

ちなみに、ここまで正しく組んでいても、AutoLayoutの矛盾によるエラーが出ていると思います。  
これは、UIScrollViewのy方向に関して、UIScrollViewの中のcontentの高さの合計値がこの時点でまだ定まっていないことによるエラーです。  
現時点では無視して大丈夫です。構築していく過程で自然と取れるようになります。

次に、レシピ説明、レシピIDを載せるViewとLabelを配置します。  
UIScrollViewの中、UIImageViewの下にViewを置き、そのViewの中にLabelを２つ置きます。(若干上下になるように置きます)  

<img src='../screenshots/chapter_4_10.png' width=600 />  

置けたら、

- Viewの上端をUIImageViewに、左端と下端をUIScrollViewに重なる
- 上のラベルは、Viewの上端、左端、右端から16pxのところに配置する
- 下のラベルは、上のラベルの下端から16px、View右端、下端から16pxのところに配置する

という制約を置きます。  

<img src='../screenshots/chapter_4_11.png' width=600 />  
<img src='../screenshots/chapter_4_12.png' width=600 />  
<img src='../screenshots/chapter_4_13.png' width=600 />  



また、上のラベルのインスペクタを開き、「Lines」を0にしておきます。これによって、長い文書が来ても自動的にLabelの高さが変わり、複数行表示されるようになります。  

<img src='../screenshots/chapter_4_14.png' width=600 />  

次に、今作成したViewと、材料を表示するViewの中間に配置する、横線入りのViewを作成します。いわゆるスペーサー的な役割を果たします。  
UIScrollViewの中、先に作ったViewの下にView(便宜上Aとします)を配置し、更にその中にView(便宜上Bとします)を配置します。  
また、View AもBも白だと分かりづらいので、Bには背景色をグレーなりの色を付けておきましょう


<img src='../screenshots/chapter_4_15.png' width=600 />  


そしたら次のように`AutoLayout`の制約を付けます

- View Aの上端を先に作ったViewの下端に、左端、右端をUIScrollViewの端に重ねる
- View Aの高さを32pxにする
- View Bに関して、上端から0px、左端から16px、右端から16pxの位置に配置する
- View Bの高さを1pxにする

<img src='../screenshots/chapter_4_16.png' width=600 />  
<img src='../screenshots/chapter_4_17.png' width=600 />  


ここまでできたら、最後に材料を表示するためのStackViewを配置します。  
「Vertical Stack View」の方をドラッグアンドドロップして配置しましょう。  

<img src='../screenshots/chapter_4_18.png' width=600 />  

StackViewを配置したら、次のように制約を付けます。  

- 上端、下端、左端、右端それぞれ0pxで配置
- 高さを200pxにする


<img src='../screenshots/chapter_4_19.png' width=600 />  

高さの制約は、この画面上でAutoLayoutの制約エラーを一時的に回避するために付けたものなので、インスペクタを開き、
「Remove at build time」にチェックを付けておきます。  

<img src='../screenshots/chapter_4_20.png' width=600 />  
<img src='../screenshots/chapter_4_21.png' width=600 />  

これで、実行時にはこの高さの制約が消えます。実行時にはこの中に入れるViewの高さの合計が高さとして見積もられるようになる(空の場合は0px)ので、この制約が取り除かれたからといってエラーになることはないです。


ここまでできたら、最後にViewControllerの各種プロパティとパーツを接続します。

<img src='../screenshots/chapter_4_22.png' width=600 />  

AutoLayoutをよりわかりやすく図にしたのがこちらです。  
１つずつじっくりとやってみましょう。(ここは若干演習として長めに時間を取ります。)

<img src='../screenshots/chapter_4_24.png' width=600 />  

## 材料を表示するためのViewを作成
先程作ったViewの中で、材料を表示するためのStackViewを配置したのですが、その中身となるViewを作成します。  

- `IngredientView.swift`
- `IngredientView.xib`

を作成します。

`IngredientView.swift`には次のようにコードを追加しておきます。

```swift
import Instantiate
import InstantiateStandard
import UIKit

final class IngredientView: UIView, NibInstantiatable {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var quantityLabel: UILabel!

    func inject(_ dependency: RecipeQuery.Data.Recipe.Ingredient) {
        nameLabel.text = dependency.name
        quantityLabel.text = dependency.quantity
    }
}
```

`IngredientView.xib`には次のようにView、Labelを配置して`AutoLayout`を設定します。  

先程の難所を越え、慣れてきた頃だと思うので、下記の図を参考に組んでみましょう。

<img src='../screenshots/chapter_4_26.png' width=600 />  
<img src='../screenshots/chapter_4_25.png' width=600 />  

注意点がいくつかあります。  

- Viewを配置すると、大きい画面が表示されてしまうので、インスペクタエリアから、`Size: freeform`を選択して、任意の大きさにできるようにします。

<img src='../screenshots/chapter_4_28.png' width=600 />  

- 左側のLabelと、`nameLabel`を、右側のLabelと`quantityLabel`を紐付けておくのを忘れずに。  
- また、`quantityLabel`は、右揃えに指定しておきましょう  
- AutoLayoutを付けるときに、Viewの端ではなく、「Safe Area」が指定されて、おかしな感じになることがあるので、下記の画像の用に、端からのpxを指定するときに、数字を指定するだけではなく、指定先のViewの情報をSafeAreaからViewにするようにしましょう

<img src='../screenshots/chapter_4_29.png' width=600 />  


## GraphQLのクエリの追加

難所を超えたら、あとはレシピ詳細を取得するためのクエリを書いて、APIClientに処理を書き、ViewModelを作成するだけになります。  
`Recipe.graphql`を開き、クエリを追加しましょう。  

```graphql
query Recipe($id: ID!) {
  recipe(id: $id) {
    id
    name
    isLiked
    description
    media {
      original
      thumbnail
    }
    ingredients {
      name
      quantity
    }
  }
}
```

```diff
// diff
query Recipes($page: Int!, $perPage: Int!) {
  recipes(page: $page, perPage: $perPage) {
    id
    name
    isLiked
    description
    media {
      thumbnail
    }
  }
}

+ query Recipe($id: ID!) {
+   recipe(id: $id) {
+     id
+     name
+     isLiked
+     description
+     media {
+       original
+       thumbnail
+     }
+     ingredients {
+       name
+       quantity
+     }
+   }
+ }
```

追加した後は、`yarn generate`をしてコードを再生成するのを忘れずに。  
コードの再生成をしたら、`APIClient.swift`に追記します。

```swift
    func getRecipe(recipeID: String, completion: @escaping (Swift.Result<RecipeQuery.Data.Recipe, Error>) -> Void) {
        getIDToken { result in
            switch result {
            case let .success(idToken):
                APIClient
                    .makeApolloClient(idToken: idToken)
                    .fetch(query: RecipeQuery(id: recipeID)) { result in
                        completion(result.flatMap { $0.data?.recipe.flatMap { .success($0) } ?? .failure(APIError.invalidResult) })
                    }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
```

## ViewModelの作成

`RecipeViewModel`を作成し、次のように実装します。  
実装方針は`RecipesViewModel`のときと変わりません。  

```swift
protocol RecipeViewModelInputs {
    func fetchRecipe()
}

protocol RecipeViewModelOutputs {
    func recipeFetched(_ block: @escaping (RecipeQuery.Data.Recipe) -> Void)
    func recipeFetchFailed(_ block: @escaping (Error) -> Void)
}

protocol RecipeViewModelType {
    init(recipeID: String)
    var inputs: RecipeViewModelInputs { get }
    var outputs: RecipeViewModelOutputs { get }
}

final class RecipeViewModel: RecipeViewModelType, RecipeViewModelInputs, RecipeViewModelOutputs {
    var inputs: RecipeViewModelInputs { return self }
    var outputs: RecipeViewModelOutputs { return self }
    private var _recipeFetched: ((RecipeQuery.Data.Recipe) -> Void)?
    private var _recipeFetchFailed: ((Error) -> Void)?
    private let recipeID: String

    init(recipeID: String) {
        self.recipeID = recipeID
    }

    func fetchRecipe() {
        APIClient.shared.getRecipe(recipeID: recipeID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(recipe):
                self._recipeFetched?(recipe)
            case let .failure(error):
                self._recipeFetchFailed?(error)
            }
        }
    }

    func recipeFetched(_ block: @escaping (RecipeQuery.Data.Recipe) -> Void) {
        _recipeFetched = block
    }

    func recipeFetchFailed(_ block: @escaping (Error) -> Void) {
        _recipeFetchFailed  = block
    }
}
```

今回は、ViewModelの初期化時に`recipeID`を渡すようにしている以外は`RecipesViewModel`とほぼ変わりません。

## 取得したデータをUIに反映する
クエリも準備し、ViewModelの作成もできたので、`RecipeViewController`に変更を加え、

- `ViewModel`の初期化
- inputs/outputsの処理を定義
- レシピデータを取得したらUIに反映する

といった実装をしていきます。

```swift
final class RecipeViewController: UIViewController, StoryboardInstantiatable {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var recipeIDLabel: UILabel!
    @IBOutlet private weak var ingredientsStackView: UIStackView!
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.sizeToFit()
        return label
    }()

    private var viewModel: RecipeViewModelType!
    private var recipe: RecipeQuery.Data.Recipe?

    func inject(_ dependency: String) {
        viewModel = RecipeViewModel(recipeID: dependency)
    }

    override func loadView() {
        super.loadView()
        navigationItem.largeTitleDisplayMode = .never
        scrollView.alwaysBounceVertical = true
        navigationItem.titleView = titleLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.outputs.recipeFetched { [weak self] recipe in
            guard let self = self else { return }
            self.recipe = recipe
            self.titleLabel.text = recipe.name
            self.titleLabel.sizeToFit()
            self.recipeImageView.kf.setImage(with: recipe.media?.original.flatMap(URL.init(string:)))
            self.descriptionLabel.text = recipe.description
            self.recipeIDLabel.text = "レシピID: \(recipe.id)"

            recipe.ingredients?.compactMap { $0 }.enumerated().forEach { index, ingredient in
                let ingredientView = IngredientView.instantiate(with: ingredient)
                ingredientView.backgroundColor = index % 2 == 0 ? .gray : .white
                self.ingredientsStackView.addArrangedSubview(ingredientView)
            }
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        viewModel.inputs.fetchRecipe()
    }
}

```

```diff
final class RecipeViewController: UIViewController, StoryboardInstantiatable {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var recipeIDLabel: UILabel!
    @IBOutlet private weak var ingredientsStackView: UIStackView!
+     private lazy var titleLabel: UILabel = {
+         let label = UILabel()
+         label.text = ""
+         label.sizeToFit()
+         return label
+     }()
+ 
+     private var viewModel: RecipeViewModelType!
+     private var recipe: RecipeQuery.Data.Recipe?

    func inject(_ dependency: String) {
-         print("recipeID", dependency)
+         viewModel = RecipeViewModel(recipeID: dependency)
    }

+     override func loadView() {
+         super.loadView()
+         navigationItem.largeTitleDisplayMode = .never
+         scrollView.alwaysBounceVertical = true
+         navigationItem.titleView = titleLabel
+     }

+     override func viewDidLoad() {
+         super.viewDidLoad()
+         viewModel.outputs.recipeFetched { [weak self] recipe in
+             guard let self = self else { return }
+             self.recipe = recipe
+             self.titleLabel.text = recipe.name
+             self.titleLabel.sizeToFit()
+             self.recipeImageView.kf.setImage(with: recipe.media?.original.flatMap(URL.init(string:)))
+             self.descriptionLabel.text = recipe.description
+             self.recipeIDLabel.text = "レシピID: \(recipe.id)"

+             recipe.ingredients?.compactMap { $0 }.enumerated().forEach { index, ingredient in
+                 let ingredientView = IngredientView.instantiate(with: ingredient)
+                 ingredientView.backgroundColor = index % 2 == 0 ? .gray : .white
+                 self.ingredientsStackView.addArrangedSubview(ingredientView)
+             }
+             self.navigationItem.rightBarButtonItem?.isEnabled = true
+         }
+         viewModel.inputs.fetchRecipe()
+     }
}
```

ここまで実装できたらビルドをして実行してみます。  
レシピデータを取得し、無事に詳細画面が崩れることなく表示されたら完成です🎉

<img src='../screenshots/chapter_4_27.png' width=375 />  

---
ここまでで、レシピの一覧から詳細、通信処理やInterface Builderを使ったUIの構築と一気通貫して学習しました！  
次は、発展課題の前の小休憩ということで、無味乾燥しているUIに魔法をかけ、見た目を改善しましょう。
