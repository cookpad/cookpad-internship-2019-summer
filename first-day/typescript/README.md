# TypeScript

## 環境構築

### Visual Studio Code

- https://code.visualstudio.com からダウンロード、インストール

自動整形されるように Prettier の拡張と保存時に自動で整形されるよう設定を変更する。

- Prettier のインストール
  - cmd + shift + p を押し「Extensions: Install Extensions」を開く
  - 「Prettier - Code formatter」を検索してインストール
  - cmd + , でセッティングを開き、formatOnSave にチェック

### Node.js

最新は 12 系だが Day 3 で v10 系を使う予定なので今日も v10 系を使う。

```
nodebrew install v10.16.3
nodebrew use v10.16.3
```

## Section 1: TypeScript のコンパイル

```
$ mkdir ~/works/typescript-handson
$ cd ~/works/typescript-handson
$ npm init -y
$ npm install -g typescript
$ tsc --init
```

生成された tsconfig.json を以下の様に修正。
デフォルトから書き換えている設定は以下の 3 点のみです。

- `noImplicitAny`を`false`
  - 暗黙の any を許容
- `"include": ["src/**/*"]`
  - TypeScript のコードを置く位置の指定
- `outDir`を`"dist"`
  - JavaScript が生成される場所

```javascript
 {
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "outDir": "dist",
    "noImplicitAny": false
  },
  "include": ["src/**/*"]
 }
```

src/hello.ts を作成し以下の様に書く

```typescript
const message: string = "Hello World";
console.log(message);
```

```
$ tsc // ファイルを指定しない場合src以下すべてがコンパイルされます
$ node dist/hello.js
Hello World
```

## Section 2 基本文法、型推論

src/basic.ts を作成し、以下のコードを写経してみる。他にも自由にコードを書いてみたり、型と違う値を入れたら VSCode がどの様になるか、複数の型の要素を 1 つの配列にいれたらどう推論されるのかなど試してみよう。

```typescript
// 再代入不可な変数。原則constを使う。
const str: string = "hello";
const array: number[] = [1, 2, 3, 4, 5];

// 再代入が必要になる場合letを使う
let myName: string = "Yuki";
myName += " Akamatsu";

// 関数

function say(message: string) {
  console.log(message);
}

const twice = function(x: number): number {
  return x * 2;
};

const sum = (x: number, y: number): number => {
  return x + y;
};

// class

class User {
  name: string;
  constructor(name: string) {
    this.name = name;
  }

  say(): string {
    return `My name is ${this.name}`;
  }
}
```

## Section 3 DOM API

index.html(src 配下ではなくルートに置く)を作成する。

```html
<html>
  <body>
    <button id="button">Create div tag</button>
    <script src="./dist/dom.js"></script>
  </body>
</html>
```

次に DOM を操作するための TS を src/dom.ts に書きコンパイルする。

```typescript
const button = document.getElementById("button")!;
button.addEventListener("click", () => {
  const div = document.createElement("div");
  div.innerHTML = "new tag";

  const body = document.getElementsByTagName("body")[0];
  body.appendChild(div);
});
```

HTML ファイルをブラウザで開き(`open index.html するとラク`)、ボタンを押す度に要素が増えていることを確認する。

余裕があれば以下のことも確かめてみる

- 1 行目の末尾の `!` を削除して再度コンパイル、動作確認してみる

## Section 4 API サーバーの用意

https://ghe.ckpd.co/yuki-akamatsu/2019-summer-intern-first-day を fork & clone し、typescript/api へ移動。
以下の手順に従い API サーバーを起動する。
cURL で JSON が取得できることを確認する。

```
$ bundle install
$ bundle exec rake db:migrate
$ bundle exec ruby db/seeds.rb
$ bundle exec rackup config.ru
$ curl http://localhost:9292/users
{"users":[{"id":1,"name":"Yuki Akamatsu"....
```

## Section 5 http モジュールでユーザーと Todo を取得する

まずは http モジュールと TypeScript 様の型定義をインストールします。

```
$ npm install -S http
$ npm install -D @types/node
```

次に src/callback.ts に以下のコードを書き、コンパイル、実行します。

```typescript
import * as http from "http";

http.get("http://localhost:9292/users", response => {
  let data = "";
  response.on("data", chunk => {
    data += chunk;
  });

  response.on("end", () => {
    const user = JSON.parse(data)["users"][0];
    const userId = user.id;

    http.get(`http://localhost:9292/users/${userId}/todos`, todoResponse => {
      let todoData = "";
      todoResponse.on("data", chunk => {
        todoData += chunk;
      });

      todoResponse.on("end", () => {
        console.log(user.name);
        console.log(JSON.parse(todoData));
      });
    });
  });
});
```

実行結果が以下の様になっていれば OK です。

```
$ node dist/callback.js
Yuki Akamatsu
{ todos:
   [ { id: 1, user_id: 1, name: '牛乳を買う' },
     { id: 2, user_id: 1, name: '部屋を片付ける' } ] }
```

## Section 6 Promise

```typescript
import * as http from "http";

function getJson(url: string): Promise<string> {
  return new Promise((resolve, reject) => {
    http.get(url, response => {
      const { statusCode } = response;

      if (statusCode !== 200) {
        const error = new Error(`Status code is ${statusCode}`);
        reject(error);
      }

      let data = "";
      response.on("data", chunk => {
        data += chunk;
      });

      response.on("end", () => {
        resolve(JSON.parse(data));
      });
    });
  });
}

getJson("http://localhost:9292/users")
  .then(json => {
    const user = json["users"][0];
    console.log(user.name);
    return getJson(`http://localhost:9292/users/${user.id}/todos`);
  })
  .then(json => {
    console.log(json);
  });

getJson("http://localhost:9292/error")
  .then(json => console.log(json)) // APIが必ずエラーになるのでここにはこない
  .catch(error => console.log(error));
```

## Section 7 Fetch API

Fetch API はブラウザ上で動く API なので、Node.js 環境では別途モジュールをインストールする必要がある。
あわせてモジュールの型定義もインストールする。

```
$ npm install -S node-fetch
$ npm install -D @types/node-fetch
```

```typescript
import fetch from "node-fetch";
fetch("http://localhost:9292/users")
  .then(response => response.json())
  .then(json => {
    const user = json.users[0];
    console.log(user.name);
    return fetch(`http://localhost:9292/users/${user.id}/todos`);
  })
  .then(response => response.json())
  .then(json => console.log(json));
```

## Section 8 Async function

```typescript
import fetch from "node-fetch";

async function fetchUsers() {
  const res = await fetch("http://localhost:9292/users");
  return res.json();
}

async function fetchTodos(userId) {
  const res = await fetch(`http://localhost:9292/users/${userId}/todos`);
  return res.json();
}

async function fetchError() {
  const res = await fetch("http://localhost:9292/error");
  if (res.status !== 200) {
    throw new Error(`Status code is ${res.status}`);
  } else {
    return res.json();
  }
}

async function main() {
  const users = await fetchUsers();
  const user = users.users[0];
  console.log(user.name);
  const todos = await fetchTodos(user.id);
  console.log(todos);
  const error = await fetchError().catch(error => error.message);
  console.log(error);
}

main();
// await は async functionの中でしか呼ぶことができない
// なのでトップレベルではawaitすることができず、main関数でラップしている
// またこのmain関数も非同期に実行されていることに注意
```
