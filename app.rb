# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

# control memo
class Memo
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def self.db
    PG.connect(dbname: 'memo')
  end

  def self.set
    Memo.db.exec('select * from memos order by id asc;').to_a
  end

  def self.memos_count
    Memo.db.exec('select count(*) from memos ;').to_a.first['count'].to_i
  end

  def memo_order
    memo_id = "select id from memos where id = '#{id}' ;"
    Memo.set.index { |i| i['id'] == Memo.db.exec(memo_id).to_a.first['id'] } + 1
  end

  def memo_content
    memo_content = "select content from memos where id = '#{id}' ;"
    Memo.db.exec(memo_content).to_a.first['content']
  end

  def content_write(content)
    Memo.db.exec("insert into memos(content) values('#{content}') ;")
  end

  def content_edit(content)
    Memo.db.exec("update memos set content = '#{content}' where id = '#{id}' ;")
  end

  def delete
    Memo.db.exec("delete from memos where id = '#{id}' ;")
  end
end

get '/new_memo' do
  erb :new_memo
end

post '/new' do
  content = params[:content]
  count = Memo.memos_count
  Memo.new(count + 1).content_write(content)
  redirect '/'
end

get '/' do
  @memos = Memo.set
  erb :top
end

get '/edition/:i' do
  @id = params[:i]
  @order = Memo.new(@id).memo_order
  @file_content = Memo.new(@id).memo_content
  erb :edition
end

patch '/memo/:i' do
  id = params[:i]
  content = params[:content]
  Memo.new(id).content_edit(content)
  redirect '/'
end

get '/memo/:i' do
  @id = params[:i]
  @order = Memo.new(@id).memo_order
  @file_content = Memo.new(@id).memo_content
  erb :memo
end

delete '/memo/:i' do
  id = params[:i]
  Memo.new(id).delete
  redirect '/'
end
