# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

# control memo
class Memo
  attr_reader :number

  def initialize(number)
    @number = number
  end

  def self.db
    PG.connect( dbname: 'memo' )
  end

  def self.set
    Memo.db.exec("select * from memos order by id asc;").to_a
  end

  def self.memos_count
    Memo.db.exec("select count(*) from memos ;").to_a.first["count"].to_i
  end

  def memo_order(id)
    Memo.set.index{|i| i['id'] == Memo.db.exec("select id from memos where id = '#{id}' ;").to_a.first['id'] } + 1
  end

  def memo_content
    Memo.db.exec("select content from memos where id = '#{number}' ;").to_a.first['content']
  end

  def content_write(content)
    Memo.db.exec("insert into memos(content) values('#{content}') ;")
  end

  def content_edit(content)
    Memo.db.exec("update memos set content = '#{content}' where id = '#{number}' ;")
  end

  def delete
    Memo.db.exec("delete from memos where id = '#{number}' ;")
  end
end

get '/new_memo' do
  erb :new_memo
end

post '/new' do
  content = params[:content]
  count = Memo.memos_count
  Memo.new(count).content_write(content)
  redirect '/'
end

get '/' do
  @memos = Memo.set
  erb :top
end

get '/edition/:i' do
  @number = params[:i]
  @order = Memo.new(@number).memo_order(@number)
  @file_content = Memo.new(@number).memo_content
  erb :edition
end

patch '/memo/:i' do
  number = params[:i]
  content = params[:content]
  Memo.new(number).content_edit(content)
  redirect '/'
end

get '/memo/:i' do
  @number = params[:i].to_i
  @order = Memo.new(@number).memo_order(@number)
  @file_content = Memo.new(@number).memo_content
  erb :memo
end

delete '/memo/:id' do
  id = params[:id]
  Memo.new(id).delete
  redirect '/'
end
