require "test/unit"
require "rack/test"
require_relative "../app"
require 'erb'

class PostsTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class << self
    def startup
      if ENV['DB_ENV'] != 'test'
        puts ENV['DB_ENV']
        puts 'Must use DB_ENV=test to run PostTest'
        exit
      end
    end

    def shutdown
      Post.connection do |db|
        db.execute('delete from posts');
      end
    end
  end

  # tests will go here
end
