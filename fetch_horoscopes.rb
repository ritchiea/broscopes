require "nokogiri"
require 'open-uri'

SUBS = [ ['aquarius','broquarius'], ['friends','brahs']].freeze

SIGNS = ["aquarius", "pisces", "aries", "taurus", "gemini", "cancer", "leo", 
		 "virgo", "libra", "scorpio", "sagittarius", "capricorn" ].freeze

def elle_url(sign)
	return nil if !SIGNS.include?(sign.downcase)
	"http://www.elle.com/horoscopes/daily/" + sign + "-daily-horoscope"
end

def bro_it_up(scope)
	SUBS.each do |sub|
		scope.gsub!(sub[0],sub[1])
	end
	scope
end

SIGNS.each do |sign|
	doc = Nokogiri::HTML(open(elle_url(sign)))

	results = doc.css(".bodySign")
	results.each do |result|
		puts bro_it_up(result.content)
	end
end