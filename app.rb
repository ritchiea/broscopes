require 'sinatra'
require 'pg'
require 'time'
require 'json'
require './pgconnect'
if ENV['environment'] != 'production'
  require 'dotenv'
  Dotenv.load
end

include PgConnect

SUBS = [ ['Aquarius','Broquarius'],
         ['friend','brah'],
         ['single','eligible'],
         ['money','stacks'],
         ['Leo','Lebro'],
         ['friends','bros'],
         ['dating','hanging out'],
         ['flirt','hit on'],
         ['salad','burger'],
         ['yoga','golf'],
         ['retail therapy','treat yo self'],
         ['spree', 'sesh'],
         ['session','sesh'],
         ['budget','bank roll'],
         ['Sunday','Sunday Funday'],
         ['conversation','real talk'],
         ['date','hook up'],
         ['relationship','relationship (bros b4 hoes)']
         ].freeze

ROOT_QUERY = <<-SQL
  select * from horoscopes as h
    where h.time > ($1)
    order by time desc
    limit 12
  SQL

before do
  @conn = connect_to_db
end

after do
  @conn.close
end

get '/' do
  @scopes = []
  @conn.exec_params ROOT_QUERY, [Time.now-(24*60*60)] do |result|
    result.each_row { |row| puts "HOROSCOPE for #{row[2]}...\n#{row[1]}"; @scopes << parse_row(row) }
  end
  haml :home, format: :html5, locals: { scopes: @scopes }
end

def parse_row(row)
  {
  id: row[0],
  content: bro_it_up(row[1]),
  sign: row[2],
  source: row[3],
  time: Time.parse(row[4]).strftime('%l:%M %P %A, %B %-d, %Y')
  }
end

def bro_it_up(horoscope)
  SUBS.each do |sub|
    horoscope.gsub!(sub[0],sub[1])
  end
  horoscope
end
