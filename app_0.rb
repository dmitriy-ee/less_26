require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'custom_database.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datestamp" TEXT,
		"barber" TEXT
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

	erb "Information recive!\n 
	Username: #{@username}\n 
	Phone: #{@phone}\n 
	Datetime: #{@datetime}\n 
	Barberbitch: #{@bb_bitch}\n"
end

get '/contact' do

end
