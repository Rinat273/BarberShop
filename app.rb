require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end		
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Users" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"username" TEXT, 
			"phone" TEXT, 
			"datestamp" TEXT, 
			"barber" TEXT, 
			"color" TEXT
		)'
	

	db.execute 'CREATE TABLE IF NOT EXISTS 
		"Barbers" 
		(
			"Id" INTEGER PRIMARY KEY AUTOINCREMENT, 
			"name" TEXT
		)'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']	
end

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

	db = get_db
	db.execute 'insert into
		Users
		(
			username,
			phone,
			datestamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@user_name, @phone, @date_time, @barber, @color]
	


	erb "<h2>Спасибо, вы записались</h2>"
	
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

get '/showusers' do
	db = get_db

	@result = db.execute 'select * from Users order by id desc'

	#db.results_as_hash = true
#db = SQLite3::Database.new 'barbershop.db'
#db.execute 'select * from Users order by id desc' do |row|
#	print row
#	puts '==========='
#end
	#erb "#{row}"

	erb :showusers
end

