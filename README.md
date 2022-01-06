# Blog Rack App

Blog website. Users can write a new article with a title and body and the app will create a new page with its own URL.

## Simple Web App

It is a very simple web app, using only Ruby, Html and Sqlite3 for the database.
The goal was to learn, practice, understand the core concepts of HTTP response and request and how Ruby works with them to build a website and to have a solid foundation for working with Ruby frameworks such as Rails and Sinatra.

The app includes a visit counter, it shows how many times you have visited the website. 

### Code 

Main Rack App `app.rb`

```ruby
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
```

Visit Counter middleware `visit_counter.rb`

```ruby
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
```


## Usage

From the project directory, use the command line and run ``` rackup config.ru ``` in order to start the server.

Choose your preferred browser and go the url `http://localhost:9292/new_article` .

Write anything you would like with a title and a text. For now, the title doesn't work with symbols when creating the URL.

Once done, you can verify by going to the proper URL : `http://localhost:9292/{titlename}` .

You might need ruby 2.7.5 to run the app.

### Tests

To run the tests : `ruby test\{test_file_name}.rb`

There is 3 test files.

`post_test.rb`

`posts_integration_test.rb`

`route_test.rb`
