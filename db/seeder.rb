require 'sqlite3'
require_relative '../config'

db = SQLite3::Database.new(DB_PATH)

puts "🧹 Tar bort gamla tabeller..."
db.execute('DROP TABLE IF EXISTS products')
db.execute('DROP TABLE IF EXISTS categories')

puts "🧱 Skapar tabeller..."

db.execute('CREATE TABLE categories (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           name TEXT NOT NULL,
           description TEXT)')

db.execute('CREATE TABLE products (
           id INTEGER PRIMARY KEY AUTOINCREMENT,
           name TEXT NOT NULL,
           tastiness INTEGER,
           description TEXT,
           category_id INTEGER)')

puts "🍎 Fyller på med data..."
db.execute('INSERT INTO categories (name, description) 
	VALUES ("Kärnfrukt", "Frukter med kärnhus i mitten.")')

db.execute('INSERT INTO categories (name, description) 
	VALUES ("Stenfrukt", "Frukter med en enda hård kärna.")')

db.execute(
'INSERT INTO products (name, tastiness, description, category_id) 
	VALUES ("Äpple", 7, "Rund frukt som…", 1)')

puts "✅ Databasen är seedad!"
