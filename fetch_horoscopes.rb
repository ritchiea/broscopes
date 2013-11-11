require "nokogiri"
require 'open-uri'

SUBS = [ ['Aquarius','Broquarius'], ['friends','brahs']].freeze

SIGNS = ["aquarius", "pisces", "aries", "taurus", "gemini", "cancer", "leo",
		 "virgo", "libra", "scorpio", "sagittarius", "capricorn" ].freeze

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

SIGNS.each do |sign|
	doc = Nokogiri::HTML(open(elle_url(sign)))

	results = doc.css(".bodySign")
	results.each do |result|
		puts bro_it_up(result.content)
	end
end
