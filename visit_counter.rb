require 'rack'

class VisitCounter
  def initialize(app)
    @app = app
  end

  def call(env)
  status, headers, body = @app.call(env)
  response = Rack::Response.new body, status, headers
  request_cookies = Rack::Utils.parse_cookies(env)

  unless request_cookies ["session_key"]
    response.set_cookie("session_key", {:value => Time.now.to_f})
  end

  count = request_cookies ["session_count"].to_i # nil.to_i returns 0, so if this cookie isn't set, the count will be 0
  count += 1
  response.set_cookie("session_count", count)

  response.finish
  end
end
