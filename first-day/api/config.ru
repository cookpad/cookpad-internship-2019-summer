require_relative "./app.rb"
run Rack::URLMap.new(App::ROUTES)
