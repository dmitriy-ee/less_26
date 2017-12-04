require 'sinatra'

get '/' do 
    erb :index
end

post '/' do
	@login = params[:LOGIN_]
	@password  = params[:PASS_]

	if @login == 'admin' && @password == '123456'
		erb :welcome
	else 
		#erb :index
		erb :access_denied
	end
end