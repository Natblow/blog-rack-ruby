require 'sqlite3'

env = ENV['DB_ENV'] || "development"
db = SQLite3::Database.new "#{env}.db"

# Create a table
db.execute <<-SQL
  create table posts (
    title varchar(50),
    body varchar(5000),
    author varchar(50)
  );
SQL
