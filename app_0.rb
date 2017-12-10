require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'custom_database.db'
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
	@bb_bitch = params[:bb_bitch]

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
				(?,?,?,?)', [@username, @phone, @datetime, @bb_bitch] 

	erb "Information recive!\n 
	Username: #{@username}\n 
	Phone: #{@phone}\n 
	Datetime: #{@datetime}\n 
	Barberbitch: #{@bb_bitch}\n"
end

get '/contact' do

end

get '/showusers' do
	db = get_db
	db.results_as_hash = true
	@res = db.execute 'SELECT * FROM Users ORDER BY Id' 
	db.close
	erb :showusers

  	# db = get_db
  	# db.results_as_hash = true
  	# db.execute 'SELECT *
  	# FROM Users' do |row|
  	# print row ['username']
  	# print "\t-\t"
  	# puts row [datestamp]
  	# puts '=============='
  	# end
end