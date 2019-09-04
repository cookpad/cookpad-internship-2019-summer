# 基礎知識

今日のモバイル講義をする上で覚えてほしいこと、言語的な部分で困ったら見返せるように書いておきます。

## Swift

Swiftは、Appleが開発し2014年に公開されたプログラミング言語です。 https://swift.org/  
今ではSwift5.xまで言語のバージョンがアップデートされ、5年前と比べて格段に進歩してきています。  
Swiftが出る以前は、iOSアプリ開発を行うにはObjective-Cという言語を使う必要がありました(あとはC、C++、Objective-C++とか)


- The Swift Programming Language - https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/


### 書き方や構文

今日の講義で使うSwiftの書き方や構文を簡単に説明しておきます。  

また、２年前のインターンの時の資料ですが、Swiftの書き方、構文が一通り掲載されている素晴らしいページがあるので貼っておきます。  
こちらもここのページじゃ不足しているなあとか感じたら読んでみてください。

#### 変数、定数
Swiftで変数を扱うときは、`var`,`let`のいずれかを使い分けることになります。  


```swift
var name: String = "Taro"

name = "Hanako" // ok

let price: Int = 12345

price = 9999 // compile error
```

#### Optional

Swiftには、Optionalという型が用意されています。これは通常の`Int`のような型と異なり、「値がない(=nil)」状態を保持することができる型となっています。  
例えば、次のコードはコンパイルエラーになります。

```swift
var price: Int = 100
price = nil // compile error
```

これは、`price`変数が、`Int`のみを受け付けるようになっている且つ、nilを許容しないためです。  
もし、あるタイミングでnilになりうる可能性がある(サーバーから取得するまではnilにしておく)、特定の条件ではnilとして扱いたいといった場合は、次のように、型に`?`を付けて表します。

```swift
var price: Int? = 100
print(price) // Optional<Int>(100)
price = nil //ok
print(price) // nil
```

このように、`Int?`とすることで、変数にnilを入れることができました。ちなみに`Int?`は`Optional<Int>`のシンタックスシュガーになります。  
ただ、このオプショナルな変数を使うと、値があるのかnilであるのかを判断する必要が出てきます。  
もし変数に値があったらその値をOptionalではないと扱ったり、nilだった場合の処理を書きたい、という場合は、`if let` / `guard let`といった構文や、Optional Chainingといった機能が用意されています(後述)

#### `if let` / `guard let` / Optional Chaining

Swiftには、Optionalな型から非Optionalな型を取り出して扱う場合、いくつかの方法が用意されています。  
`Int?`から`Int`に変換することを`unwrap(アンラップ)`と呼びます。Optionalで`wrap`(包んでいる)ものを剥がすということになります。  

そのunwrapする方法に`if let`,`guard let`があります。  
次のように用いることで、Optionalな変数に値があるかを判定し、処理を続けることができます。

```swift
var person: Person? = Person(name: "Taro")

if let person = person {
    // nilではなかったら、このブロック内に処理が移る
    print("Hi, \(person.name)")
} else {
    // nilだった場合はこちらに処理が移る
    print("person is nil")
}


guard let person = person else {
    // guard 節の場合は逆で、Optionalな変数がnilだった場合はこのブロックに処理が移り、早期return(処理の中断)を求められる
    print("person is nil")
    return
}

// guard節を抜けた後は、非Optionalな変数として扱うことが出来る
print("Hi, \(person.name)")

```

また、暗黙的にunwrapする方法もあり、Optionalな変数に`!`を付けることで暗黙的にunwrapすることが可能です。


```swift
var name: String? = "Taro"
print(name) // Optional<String>("Taro")
// 暗黙的unwrapする
print(name!) // "Taro"
```

ただし、値がセットされていない状態で暗黙的unwrapを行うと実行時クラッシュを引き起こすので注意です。

```swift
var summerVacation: Vacation? = nil
// 暗黙的unwrapする
print(summerVacation!.period) // 実行時にクラッシュする
```

また、`Optional Chaining`という構文も備わっており、Optionalな変数に対して、`?.[関数名/プロパティ]`といった具合に書くと、  
Optionalな変数に値があれば、それ以降に書いた処理を続行、nilであれば何もしない(あるいは結果としてnilを返す)といった形になります。  
例えば次のような形で使います。

```swift
var name1: String? = "Taro"
print(name1?.uppercased()) // Optional<String>("TARO")

var name2: String? = nil
print(name2?.uppercased()) // nil
```

また、`??`演算子を使うことで、左辺がnilだった場合に、右辺の非Optionalな変数で評価する、という書き方もできます。

```swift
var name1: String? = "Taro"
print((name1 ?? "no name").uppercased()) // TARO

var name2: String? = nil
print((name2 ?? "no name").uppercased()) // NO NAME
```

#### `class` / `struct`

Swiftには`class`と`struct`の２つがあり、これらを用いてインスタンスの定義をします。  
`class`は参照型ともいわれ、変数には値自体を入れるのではなく、どこに格納したかという情報(アドレス)を格納するので、  
classの中のメンバ変数が書き換わっても、classの変数自体は新しく生成しなおしたりはされません。

```swift
class Person {
    var name: String
}

let person = Person(name: "taro")
person.name = "hanako"
```

なので、class変数を`let`で定義した場合、class自体は再代入不可になりますが、中の変数は書き換えることが可能です。

一方`struct`は値型とも呼ばれ、基本的にはstructで定義された変数はデフォルトで不変なものとして扱われます。  
struct内のメンバ変数が変更されると、新しい構造体が作られ、返却されるようになっています。メンバ変数の前後で別の構造体になる、といった形です。

```swift
struct Person {
    var name: String
}

var person = Person(name: "taro")
person.name = "hanako"
```

なので、struct変数の場合、letで定義してしまうと、自身を再代入不可な上、メンバ変数の書き換えも不可になります。  
`var`を付けることで書き換えが可能になりますが、メンバ変数を書き方場合は別の構造体として再生成されることになります。  

---

今回の講義ではほぼほぼclassを使うことが多いのでそんなには迷うことはないと思います。

詳しくは[こちら](https://qiita.com/koher/items/bcdbf6578b6edd1f9e0c)が大変参考になります。  

#### protocol

protocolは、classやstruct等に対して、「こういうメソッドがある」「こういった変数を持つ」という定義を定めるものになります。  
クラスなどにprotocolを適合させた場合、protocolで定義されているものを満たさない場合はコンパイルエラーになります。

```swift
protocol Animal {
    func bark()
}

struct Cat: Animal {
    // bark()を実装しないとコンパイルエラー
}
```

また、protocolは継承させることも可能です。元のprotocolの定義を継承しつつ、新たに定義を加えることが可能です。

```swift
protocol Animal {
    func bark()
}

// Animal プロトコルを継承した新しいprotocolを定義する
protocol FlyableAnimal: Animal {
    func fly()
}

struct Hawk: FlyableAnimal {
    // bark(), fly()を実装しないとコンパイルエラー
}
```

更に、protocolには、デフォルトの実装を加えたり、拡張することができます。protocolに対して`extension`キーワードを付けることで拡張が可能です。

```swift
protocol Animal {
    func bark()
    func walk()
}

extension Animal {
    func walk() {
        print("walking...")
    }
}

struct Cat: Animal {
    func bark() {
        print("mew")
    }
}

let animal: Animal = Cat()
animal.walk() // ok
```

この例では、extensionを使いデフォルトの実装として`walk()`関数を実装したので、protocolの継承元が`walk()`を実装していなくてもコンパイルエラーにならず、デフォルトの実装を呼び出すことができます。  
もちろん、適合元となるクラスが`walk()`を実装することもでき、その場合はクラスで実装した処理が優先されます
<br />

次のコードは今までに出したコードの例のまとめです。`Animal`プロトコルを定義して、`Cat`,`Dog`という２つの型に適合させます。  
そうすると、`Cat`と`Dog`の型は`bark`という関数の定義を強制されます。  
また、`Animal`プロトコルに準拠することになるので、`var animal: Animal`という方に、`cat`も`dog`も代入して同じように扱うことができるようになります。

```swift
protocol Animal {
    func bark()
    func walk()
}

extension Animal {
    func walk() {
        print("walking...")
    }
}

protocol FlyableAnimal: Animal {
    func fly()
}

struct Cat: Animal {
    func bark() {
        print("mew")
    }
}

struct Dog: Animal {
    func bark() {
        print("bowwow")
    }
}

struct Hawk: FlyableAnimal {
    func bark() {

    }

    func fly() {
        print("flying...")
    }
}

let cat = Cat()
let dog = Dog()

var animal: Animal = cat
animal.bark()
animal = dog
animal.bark()
animal.walk()

// 以下はコンパイルエラー
var anotherCat: Cat = Cat()
anotherCat = dog
animal.fly()
var flyableAnimal: FlyableAnimal = Hawk()
flyableAnimal = dog
```

protocolにはもっと複雑な仕様があります(Generics、Associated Value、Type-Erasure等、もっと言語仕様としては深いところがあります)が、今回はそこまで込み入った使い方をしないので割愛します。  
基本的にはこのように、Swiftで書いていく上では、protocolの定義をうまく活用しながら、共通化したり、特定のprotocolに適合しているときだけ処理を行わせる、といった形になってきます。  
Objective-Cの頃のiOS開発では、オブジェクト指向で設計をしていくことが主流でしたが、今ではプロトコル指向(Protocol Oriented Programming)で設計していくのが主になってきています。  
(注: クラスの継承が悪い、という意味ではありません.)

#### `@IBOutlet`

`@IBOutlet`は、変数に付けるattributeの１つで、この`@IBOutlet`をUIKitのUIパーツのクラス(`UILabel等`)に付けることで、  
xibやstoryboardで作成したViewのパーツとその変数を接続することができるようになります。  
これによって、xibやstoryboardがロードされたときに、そのVieｗの情報が変数に格納されて参照できるので、初期状態からUILabelの文字を変えたりする、といったことが変数を通して可能になります。
`@IBOutlet`を使うときは、変数は原則`weak var`を付けて、Optionalな型として扱うことになります。これは、ロードが完了するまでは変数に値がない状態ができるためです。

```swift
final class ViewController: UIViewController {
    // ロードされるまではこの変数にはnilが入ってきます
    @IBOutlet private weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // xib/storyboardで接続したUILabelの参照が入ってくる
        print(label.text)
        label.text = "Cookpad Inc." // 書き換えも可能
    }
}
```

#### デリゲート(delegate)

deletate(移譲という意味の単語ですね)は、「あるクラスの特定の処理を、他のクラスのインスタンスに処理を任せる(移譲)」するためのパターンの一つです。  
そのときに、`protocol`を使うことになります。
delegateを使うことによって、移譲元は`protocol`に適合した移譲先インスタンスの処理を呼び出すだけでよく、それ以外の移譲先のインスタンスが何であるかを気にしなくて済む、というのがあります。  
簡単な例を以下に示します。Aのクラスでアイテムの合計金額を算出して出力する処理があるのですが、その金額の合計を求める部分を`ADelegate`に適合したBクラスに移譲するようにしています。

```swift
struct Item {
    let price: Int
}

protocol ADelegate {
    func calculateTotalPrice(from items: [Item]) -> Int
}

class A {
    weak var delegate: ADelegate?
    private let items: [Item] = ...
    func printTotalPrice() {
        let total = delegate?.calculateTotalPrice(from: items) ?? 0
        print("Total: \(total)")
    }
}

class B: ADelegate {
    func calculateTotalPrice(from items: [Item]) -> Int {
        return items.reduce(0, { $0 += $1.price })
    }
}

let a = A()
let b = B()

a.delegate = b

a.printTotalPrice()
```

今日の講義では、`UITableViewDelegate`,`UITableViewDataSource`という２つのdelegateがでてきます。

## Xcode

iOSアプリ開発をする上で必須となる(IDE)エディタ。  
コードを書くだけであれば、VSCode、vimといったエディタでも問題ないが、

- ビルドをして実行する
- Interface Builder(後述)を使ってUIの見た目を作る
- アプリのバイナリを作成する

といった作業をするとなると、エディタだけでは完結しなくなり、CLI等を使う必要があるので、Xcodeを使うのが無難です。

## Interface Builder

Xcode上で、GUI操作でアプリ内の画面で使うUIを構築していくためのエディタの機能の一つです。  
コードでUIを構築するのと比べて、視覚的にUIを構築していくことができるので、分かりやすいです。

## AutoLayout

iOSアプリ開発をする上で、今では避けて通れないもので、初見殺しがすごいのがこのAutoLayoutです。  
はるか昔、iOS6以前までの頃は、自分たちで端末の大きさなどを考慮して、座標計算をしてViewを配置したりしていたのですが、  
この「AutoLayout」というのが搭載されて以降は、  
「このViewは、画面に対して中央に配置する」、「このViewは、親のViewの横幅の2/3の大きさで、左端から32px離れたところに配置する」といった「**制約**」ベースでViewの位置などを決めるようになりました。  
これによって、今ではiPhone SE,iPhone X, iPadといった異なるサイズの画面に柔軟に対応できるようになっています。  
先述のInterface Builder上、あるいはコード上で、このAutoLayoutを使うことになります。

## (おまけ)Android

> Android（アンドロイド）は、Googleが開発したモバイルオペレーティングシステムである。

- 出典: wikipedia: https://ja.wikipedia.org/wiki/Android

モバイルアプリ開発となると、基本的にはiOSかAndroidのいずれかのプラットフォームでの開発のことになる。  

近年では、マルチプラットフォーム開発をするためのフレームワークが増えてきていて、`React Native`, `Flutter` といったものもある
