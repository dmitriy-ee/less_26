require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	(db.execute 'SELECT * FROM Barbers WHERE name=(?)', [name]).length > 0
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

before do
	db = get_db
	@res_barber = db.execute 'SELECT * FROM Barbers ORDER BY Id'
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

get '/' do
	@error = 'Something wrong!!!'
	erb :layout
end

get '/login/form' do
	erb :login_form
end

post '/' do
	@user_login = params[:user_login]
	@user_pass = params[:user_pass]
	erb :layout
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]

	hh =    {
			:username => 'Please, enter your name',
			:phone => 'Please, enter your phone', 
			:datetime => 'Please, enter visit day & time'
			}

	@error = hh.select {|key,_| params[key] == ""}.values.join("; ")

	if @error != ''
		return erb :visit
	end
	# Easy version 
	# hh.each do |key, value|
	# 	if params[key] == ''
	# 		@error = hh[key]
	# 	return erb :visit
	# 	end
	# end
	db = get_db
	db.execute 'INSERT INTO 
				Users
				(
				username,
				phone,
				datestamp,
				barber
				)
				VALUES
				(?,?,?,?)', [@username, @phone, @datetime, @barber] 

	erb "Information recive!\n 
	Username: #{@username}\n 
	Phone: #{@phone}\n 
	Datetime: #{@datetime}\n 
	Barberbitch: #{@barber}\n"
end

get '/contact' do
 'contact...'
end

get '/showusers' do
	db = get_db
	@res = db.execute 'SELECT * FROM Users ORDER BY Id' 
	erb :showusers 
end