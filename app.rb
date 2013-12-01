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

SUBS = [ ["\u0085", '...'],
         ["\u0092", "'"],
         ['Aquarius','Broquarius'],
         [/ friend[^l]/,' brah'],
         ['soiree','house party'],
         ['object of your affections', 'those digits from last weekend'],
         ['single','eligible'],
         ['money','stacks'],
         ['Leo','Lebro'],
         ['friends','bros'],
         ['dating','hanging out'],
         ['flirt','hollar at'],
         ['salad','burger'],
         ['yoga studio', 'driving range'],
         ['yoga','golf'],
         ['retail therapy','treat yo self'],
         ['spree', 'sesh'],
         ['spin class', 'crossfit'],
         [/\ session\ /,' sesh'],
         ['budget','bank roll'],
         ['Sunday','Sunday Funday'],
         ['conversation','real talk'],
         ['date','hook up'],
         [/haute /,''],
         ['conflict', 'beef'],
         ['long brunch', 'long brew sesh'],
         ['brunch', 'brews'],
         ['sexy', 'smokin'],
         ['fun', 'mad fun'],
         ['tension', 'heat'],
         ['emotions', 'bromotions'],
         ['emotional', 'brahmotional'],
         ['romances', 'bang sessions'],
         ['romance ', 'bang sesh'],
         ['relationship ','relationship (reminder: bros b4 hoes)']
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
    result.each_row { |row| @scopes << parse_row(row) }
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
