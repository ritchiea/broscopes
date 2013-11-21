require "nokogiri"
require 'open-uri'
require 'pg'
require 'time'
require './pgconnect'

include PgConnect

SIGNS = ["aquarius", "pisces", "aries", "taurus", "gemini", "cancer", "leo",
     "virgo", "libra", "scorpio", "sagittarius", "capricorn" ].freeze

namespace :db do
  desc 'create horoscopes table'
  task :create_table_horoscopes do
    @conn = connect_to_db
    @conn.exec <<-SQL
     CREATE TABLE IF NOT EXISTS horoscopes (
     id SERIAL PRIMARY KEY,
     content text NOT NULL,
     sign varchar(255) NOT NULL,
     source varchar(255) NOT NULL,
     time timestamp
     );
    SQL
    @conn.close
  end
end

def elle_url(sign)
  return nil if !SIGNS.include?(sign.downcase)
  "http://www.elle.com/horoscopes/daily/" + sign + "-daily-horoscope"
end

desc 'fetch horoscopes'
task :fetch_elle do
  @conn = connect_to_db
  SIGNS.each do |sign|
    doc = Nokogiri::HTML(open(elle_url(sign)))

    doc.css(".bodySign").each do |result|
      puts "Adding...\n #{result.content.strip}"
      @conn.exec_params("INSERT INTO horoscopes (content,sign,source,time) VALUES ($1, $2, $3, $4)",
        [result.content.strip,sign,'elle',Time.now])
    end
  end
  @conn.close
end
