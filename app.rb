# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'fileutils'

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
  @files = Dir.glob('./public/memos/*')
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

delete '/memo/:i' do
  number = params[:i]
  File.delete("./public/memos/#{number}.txt")
  files = Dir.glob('./public/memos/*')
  files.each do |f|
    i = f.gsub('./public/memos/', '').gsub('.txt', '').to_i
    FileUtils.mv(f, "./public/memos/#{i - 1}.txt") if i > number.to_i
  end
  redirect '/'
end
