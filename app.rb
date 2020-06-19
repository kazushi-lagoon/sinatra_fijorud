# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

get '/new_memo' do
  erb :new_memo
end

post '/new' do
  content = params[:content]
  number = Dir.open('./public/memos').children.count
  File.open("./public/memos/#{number + 1}.txt", 'wb') do |f|
    f.write(content)
  end
  redirect '/'
end

get '/' do
  @number = Dir.open('./public/memos').children.count
  erb :top
end

get '/edition/:i' do
  @number = params[:i]
  @file_content = File.open("./public/memos/#{@number}.txt").read
  erb :edition
end

patch '/memo/:i' do
  number = params[:i]
  content = params[:content]
  File.open("./public/memos/#{number}.txt", 'wb') do |f|
    f.write(content)
  end
  redirect '/'
end

get '/memo/:i' do
  @number = params[:i]
  @file_content = File.open("./public/memos/#{@number}.txt").read
  erb :memo
end

delete '/memo/:id' do
  number = params[:id]
  File.delete("./public/memos/#{number}.txt")
  redirect '/'
end
