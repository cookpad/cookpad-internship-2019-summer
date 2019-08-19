# Ruby

## 環境構築

```sh
$ rbenv install 2.6.3
```

## section 1 Rack アプリケーション

```sh
$ mkdir -p ~/works/rack-app
$ cd ~/works/rack-app
$ bundle init
```

生成された Gemfile を以下の様に修正する。

```diff
 git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

-# gem "rails"
+gem "rack"
```

修正後、 bundle install を実行し rack をインストールする。

```sh
$ bundle install
```

次にアプリケーションコードを書いていく。 app.rb という名前のファイルを作り以下の様に書く。

### app.rb の編集

```ruby
class App
  def call(env)
    [
      200,
      { 'Content-Type' => 'text/html; charset=utf-8' },
      ['<html><body>Hello World.</body></html>']
    ]
  end
end
```

### config.ru の編集

```ruby
require "bundler/setup"
Bundler.require

require_relative "./app"
run App.new
```

### アプリケーションの立ち上げ

```sh
$ bundle exec rackup config.ru
INFO  WEBrick 1.4.2
INFO  ruby 2.6.2 (2019-03-13) [x86_64-darwin18]
INFO  WEBrick::HTTPServer#start: pid=11145 port=9292
```

ブラウザで http://localhost:9292 にアクセス。「Hello World」と表示されていることを確認する。

### エンドポイントを増やす (app.rb)

`Rack::Request`のインスタンスを作ると、path_info メソッドを呼び出すことでどのパスに対してリクエストされたか知ることができる。
パスが`/`のときと`/welcome`の時で動作を変更する。

```diff
 class App
   def call(env)
+    request = Rack::Request.new(env)
+    message =
+      if request.path_info == "/welcome"
+        "Welcome to Cookpad"
+      else
+        "Hello World"
+      end
+
     [
       200,
       { 'Content-Type' => 'text/html; charset=utf-8' },
-      ['<html><body>Hello World.</body></html>']
+      ["<html><body>#{message}</body></html>"]
     ]
   end
 end

end
```

http://localhost:9292 と http://localhost:9292/welcome にアクセスしてそれぞれの表示内容を確認し、表示されている内容が違うことを確認する。
注意: サーバーの再起動が必要(ctrl-c でサーバーを落とした後に再度起動)

### POST リクエストに対応する (app.rb)

path_info メソッドと同様に request_method メソッドを呼ぶとリクエストの HTTP メソッドを取得をすることができる。
HTTP メソッドが POST の時の動作を変更する。

```diff
@@ -2,10 +2,14 @@ class App
   def call(env)
     request = Rack::Request.new(env)
     message =
-      if request.path_info == "/welcome"
-        "Welcome to Cookpad"
+      if request.request_method == "POST"
+        "Hello Rack"
       else
-        "Hello World"
+        if request.path_info == "/welcome"
+          "Welcome to Cookpad"
+        else
+          "Hello World"
+        end
       end

     [

```

POST リクエストを確認するにはターミナルで cURL を使用する。(ブラウザで確認する場合フォームが必要)

```sh
$ curl -X POST http://localhost:9292 -d {}
```

HTML 文字列と一緒に「Hello Ruby」と表示されていることを確認

## section 2 ルーティングとコントローラー

```diff
 class App
   def call(env)
     request = Rack::Request.new(env)
-    message =
-      if request.request_method == "POST"
-        "Hello Rack"
-      else
-        if request.path_info == "/welcome"
-          "Welcome to Cookpad"
-        else
-          "Hello World"
-        end
-      end
+    case request.path_info
+    when "/"
+      RootController.new(request).index
+    when "/welcome"
+      WelcomeController.new(request).index
+    end
+  end
+end

+class BaseController
+  def initialize(request)
+    @request = request
+  end
+
+  def render(content)
     [
       200,
       { 'Content-Type' => 'text/html; charset=utf-8' },
-      ["<html><body>#{message}</body></html>"]
+      ["<html><body>#{content}</body></html>"]
     ]
   end
 end
+
+# / にリクエストが来た時のコントローラー
+class RootController < BaseController
+  def index
+    if @request.request_method == "POST"
+      render "Hello Rack"
+    else
+      render "Hello World"
+    end
+  end
+end
+
+# /welcom にリクエストが来た時のコントローラー
+class WelcomeController < BaseController
+  def index
+    render "Welcome to Cookpad"
+  end
+end
```

## Section 3 View の実装

```diff
 class BaseController
   def initialize(request)
     @request = request
   end

-  def render(content)
-    [
-      200,
-      { 'Content-Type' => 'text/html; charset=utf-8' },
-      ["<html><body>#{content}</body></html>"]
-    ]
+  def render(content: nil, template: nil)
+    response_body =
+      case
+      when content
+        "<html><body>#{content}</body></html>"
+      when template
+        ERB.new(File.read(template)).result(binding)
+      else
+        raise ArgumentError
+      end
+
+      [
+        200,
+        { 'Content-Type' => 'text/html; charset=utf-8' },
+        [response_body]
+      ]
   end
 end

 # / にリクエストが来た時のコントローラー
 class RootController < BaseController
   def index
     if @request.request_method == "POST"
-      render "Hello Rack"
+      render content: "Hello Rack"
     else
-      render "Hello World"
+      @name = "Your Name"
+      render template: "views/root/index.html.erb"
     end
   end
 end

 # /welcom にリクエストが来た時のコントローラー
 class WelcomeController < BaseController
   def index
-    render "Welcome to Cookpad"
+    render content: "Welcome to Cookpad"
   end
 end
```

新規に View ファイルを追加する

```
$ mkdir -p views/root
$ touch views/root/index.html.erb
```

```html
<h1>Hello World</h1>
<p>I'm <%= @name %></p>
```

## Section 4 データベースのデータを画面に表示

### データベースの作成

Gemfile に sqlite3 gem を追加 & bundle isntall してインストールする。

```diff
 gem "rack"
+gem "sqlite3"
```

```sh
bundle install
```

データベースの作成と初期データを投入するスクリプト、 seeds.rb を実装する。

```ruby
require "sqlite3"
require "time"

db = SQLite3::Database.new("app.sqlite3")

db.execute(<<~SQL)
  create table todos (
    name varchar(255),
    created_at varchar(255)
  )
SQL

db.execute("insert into todos (name, created_at) values (?, ?)", ["牛乳を買う", Time.now.to_s])
db.execute("insert into todos (name, created_at) values (?, ?)", ["ゴミを捨てる", Time.now.to_s])
db.execute("insert into todos (name, created_at) values (?, ?)", ["晩御飯を作る", Time.now.to_s])
```

```sh
$ bundle exec ruby seeds.rb
```

実行後、`app.sqlite3`が作成されていることを確認。
sqlite3 コマンドで DB に接続することができるので、実際にデータが入っているか確認する。

```sh
$ sqlite3 app.sqlite3
sqlite> select * from todos;
牛乳を買う|2019-08-19 10:00:00 +0900
ゴミを捨てる|2019-08-19 10:00:00 +0900
晩御飯を作る|2019-08-19 10:00:00 +0900
```

### Model の実装

app.rb に Todo クラスを追加する。

```diff
+# todosテーブルのレコードにマッピングするモデル
+class Todo
+  attr_accessor :name, :created_at
+
+  def self.all
+    db = SQLite3::Database.new("app.sqlite3")
+    rows = db.execute("select * from todos")
+    rows.map do |name, created_at|
+      self.new(name: name, created_at: created_at)
+    end
+  end
+
+  def initialize(name:, created_at:)
+    @name = name
+    @created_at = created_at
+  end
+end
```

### TodosController の実装

Todo 一覧を表示する `/todos` のために TodosController の実装とルーティングの対応を行なう。

```diff
 class App
   def call(env)
     request = Rack::Request.new(env)
     case request.path_info
     when "/"
       RootController.new(request).index
     when "/welcome"
       WelcomeController.new(request).index
+    when "/todos"
+      TodosController.new(request).index
     end
   end
 end

 class BaseController
   def initialize(request)
     @request = request
   end

   def render(content: nil, template: nil)
     response_body =
       case
       when content
         "<html><body>#{content}</body></html>"
       when template
         ERB.new(File.read(template)).result(binding)
       else
         raise ArgumentError
       end

       [
         200,
         { 'Content-Type' => 'text/html; charset=utf-8' },
         [response_body]
       ]
   end
 end

 # / にリクエストが来た時のコントローラー
 class RootController < BaseController
   def index
     if @request.request_method == "POST"
       render content: "Hello Rack"
     else
       @name = "Your Name"
       render template: "views/root/index.html.erb"
     end
   end
 end

 # /welcom にリクエストが来た時のコントローラー
 class WelcomeController < BaseController
   def index
     render content: "Welcome to Cookpad"
   end
 end
+
+class TodosController < BaseController
+  def index
+    @todos = Todo.all
+    render template: "views/todos/index.html.erb"
+  end
+end
```

```erb
<ul>
  <% @todos.each do |todo| %>
    <li><%= todo.name %></li>
  <% end %>
</ul>
```
