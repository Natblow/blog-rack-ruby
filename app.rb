require 'rack'
require 'cgi'
require_relative 'view'
require_relative 'route'
require_relative 'post'


class App
  def call(env)
    response_headers = {}

    request_cookies= Rack::Utils.parse_cookies(env)

    route = Route.new(env)
    status = route.name =~ /^\d\d\d$/ ? route.name.to_i : 200

    template_data = {
      visit_count: request_cookies["session_count"].to_i + 1
    }

    if env["REQUEST_METHOD"] == "POST"
      params = CGI::parse(env["rack.input"].read)
      title = params["title"] && params["title"].first
      body = params["body"] && params["body"].first

      template_data[:post] = Post.create title: title, body: body
    elsif route.name == :user_article
      template_data[:post] = Post.find "#{env["PATH_INFO"]}".sub('/', '')
    end

    template = View.new(route.name, template_data)

    [status , response_headers , [template.render]]
  end
end
