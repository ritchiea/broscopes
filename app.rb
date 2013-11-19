require 'sinatra'
require 'pg'
require 'time'
require 'json'

before do
  @conn = PG::Connection.open(dbname: 'broscopes')
end

after do
  @conn.close
end

get '/' do
  @scopes = []
  @conn.exec 'select * from horoscopes' do |result|
    result.each_row { |row| scopes << parse_row(row) }
  end
  haml :home, format: :html5, locals: { scopes: @scopes }
end

def parse_row(row)
  {
  id: row[0],
  content: row[1],
  sign: row[2],
  source: row[3],
  time: Time.parse(row[4]).strftime('%l:%M %P %A, %B %-d, %Y')
  }
end
