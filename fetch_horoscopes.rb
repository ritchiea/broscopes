require "nokogiri"
require 'open-uri'
require 'pg'
require 'time'

SUBS = [ ['Aquarius','Broquarius'], ['friends','brahs']].freeze

SIGNS = ["aquarius", "pisces", "aries", "taurus", "gemini", "cancer", "leo",
		 "virgo", "libra", "scorpio", "sagittarius", "capricorn" ].freeze

conn = PG::Connection.open(dbname: 'broscopes')
conn.exec <<-SQL
 CREATE TABLE IF NOT EXISTS horoscopes (
 id SERIAL PRIMARY KEY,
 content text NOT NULL,
 sign varchar(255) NOT NULL,
 source varchar(255) NOT NULL,
 time timestamp
 );
SQL

def elle_url(sign)
	return nil if !SIGNS.include?(sign.downcase)
	"http://www.elle.com/horoscopes/daily/" + sign + "-daily-horoscope"
end

def bro_it_up(horoscope)
	SUBS.each do |sub|
		horoscope.gsub!(sub[0],sub[1])
	end
	horoscope
end

def fetch_signs(connection)
  SIGNS.each do |sign|
    doc = Nokogiri::HTML(open(elle_url(sign)))

    doc.css(".bodySign").each do |result|
      puts "Adding...\n #{result.content.strip}"
      connection.exec_params("INSERT INTO horoscopes (content,sign,source,time) VALUES ($1, $2, $3, $4)",
        [result.content.strip,sign,'elle',Time.now])
    end
  end
end

fetch_signs conn

conn.close
