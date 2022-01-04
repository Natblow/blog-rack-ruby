require 'uri'
require_relative 'post'

class Route
  ROUTES = {
    "GET" => {
      "/garbatella"  => :garbatella,
      "/testaccio"   => :testaccio,
      "/eur"         => :eur,
      "/new_article" => :new_article,
    },
    "POST" => {
      "/new_article" => :user_article
    }
  }

  attr_accessor :name

  def initialize(env)
    http_method = env["REQUEST_METHOD"]
    path = env["PATH_INFO"]
    @name = ROUTES[http_method] && ROUTES[http_method][path]

    unless @name
      @name = :user_article if Post.exists?("#{path}".sub('/', ''))
    end
  end

  def name
    @name || "404"
  end
end
