require "sinatra/base"
class App < Sinatra::Base
  get("/")   { "ruby-sinatra-rackup up\n" }
  get("/up") { "ok\n" }
end
