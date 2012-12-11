#!/usr/bin/env ruby
#

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class NinjaslayerTogetter
	@@urls = %w(
		http://togetter.com/li/73081
	)

	def initialize
		@data = Hash.new
		parse
	end

	def parse
		@@urls.each do |url|
			doc = Nokogiri::HTML open(url)
			title = doc.xpath('//a[@class="info_title"]/@title').first.value
			tweets = []
			doc.xpath('//div[@class="tweet"]').each do |tweet|
				tweets << tweet.text
			end
			data = @data[url] = {}
			data[:title] = title
			data[:tweets] = tweets
			return data
		end
	end

	def pages
		pages = []
		@@urls.each do |url|
			data = @data[url]
			title = data[:title]
			tweets = data[:tweets]
			lines = []
			lines << '=' * title.bytesize
			lines << title
			lines << '=' * title.bytesize
			lines << ''
			tweets.each do |tweet|
				lines << tweet
				lines << ''
			end
			
			pages << (lines.join "\n")
		end
		return pages
	end
end



if __FILE__ == $0 then
	nt = NinjaslayerTogetter.new
	puts nt.pages
end


