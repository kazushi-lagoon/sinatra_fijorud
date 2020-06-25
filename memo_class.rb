# frozen_string_literal: true

# control memo
class Memo
  attr_reader :id, :db

  def initialize(id)
    @id = id
  end

  def self.set
    Memo.db.exec('select * from memos order by id asc;').to_a
  end

  def self.count
    Memo.db.exec('select count(*) from memos ;').to_a.first['count'].to_i
  end

  def self.db
    @db ||= PG.connect(dbname: 'memo')
  end

  def order
    Memo.set.index { |i| i['id'] == id } + 1
  end

  def content
    content = 'select content from memos where id = $1 ;'
    Memo.db.exec(content, [id]).to_a.first['content']
  end

  def write_content(content)
    Memo.db.exec('insert into memos(content) values($1) ;', [content])
  end

  def edit_content(content)
    update = 'update memos set content = $1 where id = $2 ;'
    Memo.db.exec(update, [content, id])
  end

  def delete
    delete = 'delete from memos where id = $1 ;'
    Memo.db.exec(delete, [id])
  end
end
