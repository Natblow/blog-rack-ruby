require 'sqlite3'

class Post
  attr_accessor :title, :body
  DB_ENV = ENV['DB_ENV'] || 'development'

  def self.connection
    db = SQLite3::Database.open("database/#{DB_ENV}.db")
    r = yield db
    db.close
    return r
  end

  def self.exists?(title)
    result = self.connection do |db|
      db.execute("select count() from posts where title = ?", [title])
    end

    return result[0][0] > 0
  end

  def self.find(title)
    result = self.connection do |db|
      db.execute("select * from posts where title = ?", [title])
  end

    if result.length > 0
      self.new title: result[0][0], body: result[0][1]
    else
      nil
    end
  end

  def self.create(params)
    result = self.connection do |db|
      db.execute("INSERT INTO posts(title, body) VALUES(?, ?)", [params[:title], params[:body]])
    end

    self.new params
  end

  def initialize(params)
    @title = params[:title]
    @body = params[:body]
  end
end
