require_relative 'test_helper'
require_relative '../post'

class PostTest < Test::Unit::TestCase
  class << self
    def startup
      if ENV['DB_ENV'] != 'test'
        puts ENV['DB_ENV']
        puts 'Must use DB_ENV=test to run PostTest'
        exit
      end

      post_fixtures = [
        {
          title: 'one',
          body: 'one body'
        },
        {
          title: 'two',
          body: 'two body'
        }
      ].map { |params| Post.create params }
    end

    def shutdown
      Post.connection do |db|
        db.execute('delete from posts');
      end
    end
  end

  def test_that_it_creates_a_post
    title = 'testpost'
    body = 'testpost body'
    Post.create(title: title, body: body)
    post = Post.find(title)
    assert_equal(body, post.body, "expected post with title '#{title}' to have been created")
  end

  def test_that_it_finds_a_post
    post = Post.find('one')
    assert_equal post.body, 'one body'
  end
end
