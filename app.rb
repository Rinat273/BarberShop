require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

post '/' do
	
	@login = params[:aaa]
	@password = params[:bbb]
	
	if @login == 'admin' && @password == 'secret'
		erb :layout
	#elsif @login == 'admin' && @password == 'admin'
	#	@message = 'Haha, nice try! Access denied'
	#	erb :admin
	else
		@messages = 'Access denied'
		erb :index
	end
end

get '/index' do 
	erb :index
end

get '/about' do
	@error = 'something wrong!'
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@user_name = params[:user_name]
	@phone	   = params[:phone]
	@date_time = params[:date_time]
	@barber    = params[:barber]
	@color     = params[:color]

	# хеш
	hh = {  :user_name => 'Введите имя',
	 		:phone => 'Введите телефон',
	 		:date_time => 'Введите дату и время'}

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end


	erb "Ok, #{@user_name}, #{@phone}, #{@date_time}, #{@barber}, #{@color}"
	
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@email  = params[:email]
	@message = params[:message]

	# хеш
	hh = {  :email => 'Введите e-mail',
	 		:message => 'Введите сообщение',
	 	 }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :contacts
	end


	erb "Ok, #{@email}, #{@message}"

		
end