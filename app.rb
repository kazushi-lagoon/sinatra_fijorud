require 'sinatra'
require 'sinatra/reloader'

class Rack::MethodOverride
  ALLOWED_METHODS=%w[POST GET]
  def method_override(env)
    req = Rack::Request.new(env)
    method = req.params[METHOD_OVERRIDE_PARAM_KEY] || env[HTTP_METHOD_OVERRIDE_HEADER]
    method.to_s.upcase
  end
end

enable :method_override

get '/new_memo' do
  erb :new_memo
end

post '/new' do
  content = params[:content]
  number = Dir.open('./public/memos').children.count
  File.open("./public/memos/#{number+1}.txt", 'wb') do |f|
    f.write(content)
  end
  redirect '/'
end

get '/' do
  @number = Dir.open('./public/memos').children.count
  #binding.irb
  erb :top
end

get '/edit_memo/:i' do
  @number = params[:i]
  @file_content = File.open("./public/memos/#{@number}.txt").read
  erb :edit_memo
end

patch '/edit_memo/:i' do
  number = params[:i]
  content = params[:content]
  File.open("./public/memos/#{number}.txt", 'wb') do |f|
    f.write(content)
  end
  redirect '/'
end

get '/show_memo/:i' do
  @number = params[:i]
  @file_content = File.open("./public/memos/#{@number}.txt").read
  erb :show_memo
end

delete '/memo/:id' do
  number = params[:id]
  File.delete("./public/memos/#{number}.txt")
  redirect '/'
end
