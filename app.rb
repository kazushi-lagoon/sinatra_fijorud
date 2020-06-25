# frozen_string_literal: true

require_relative 'memo_class'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'

get '/new_memo' do
  erb :new_memo
end

post '/new' do
  content = params[:content]
  count = Memo.count
  Memo.new(count + 1).write_content(content)
  redirect '/'
end

get '/' do
  @memos = Memo.set
  erb :top
end

get '/edition/:id' do
  @id = params[:id]
  memo = Memo.new(@id)
  @order = memo.order
  @file_content = memo.content
  erb :edition
end

patch '/memo/:id' do
  id = params[:id]
  content = params[:content]
  Memo.new(id).edit_content(content)
  redirect '/'
end

get '/memo/:id' do
  @id = params[:id]
  memo = Memo.new(@id)
  @order = memo.order
  @file_content = memo.content
  erb :memo
end

delete '/memo/:id' do
  id = params[:id]
  Memo.new(id).delete
  redirect '/'
end
