require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute ('SELECT * FROM Barbers WHERE name=?', [name]).size > 0
end

def seed_db db, barbers
	barbers.each do |barber|
	if !is_barber_exists? db, barber
		db.execute 'INSERT INTO Barbers (name) VALUES (?)', [barber]
	end
	end
end


def get_db
	db = SQLite3::Database.new 'custom_database.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datestamp" TEXT,
		"barber" TEXT
		)'

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers"
		(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" TEXT
		)'

	seed_db db, ['Barberbitch_1', 'Barberbitch_2', 'Barberbitch_3', 'Barberbitch_4', 'Barberbitch_5']	
end