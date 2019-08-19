require "bundler/setup"
Bundler.require
require "sinatra/json"
require "sinatra/reloader"

require_relative "./models.rb"

set :database, "sqlite3:app.sqlite3"

class RootController < Sinatra::Base
  get "/" do
    res = { message: "Hello World" }
    json res
  end

  get "/error" do
    status 500
    res = { error: "error" }
    json res
  end
end

class UsersController < Sinatra::Base
  get "/" do
    json users: User.all
  end

  get "/:id" do
    user = User.find(params[:id])
    json user: user
  end

  get "/:id/todos" do
    user = User.find(params[:id])
    json todos: user.todos
  end
end

class App < Sinatra::Base
  ROUTES = {
    "/" => RootController,
    "/users" => UsersController
  }
end
