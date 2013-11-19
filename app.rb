require 'sinatra'
require 'pg'
require 'time'
require 'json'
if ENV['environment'] != 'production'
  require 'dotenv'
  Dotenv.load
end

SUBS = [ ['Aquarius','Broquarius'],
         ['friend','brah']
        ].freeze

before do
  if ENV['environment'] == 'dev'
    @conn = PG::Connection.open(dbname: 'broscopes')
  else
    db = URI.parse(ENV['DATABASE_URL'])
    @conn = PG::Connection.new( {host: db.host, user: db.user, port: db.port, password: db.password, dbname:db.path[1..-1] } )
  end
end

after do
  @conn.close
end

get '/' do
  @scopes = []
  @conn.exec 'select * from horoscopes' do |result|
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
