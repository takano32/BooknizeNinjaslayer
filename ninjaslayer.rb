#!/usr/bin/env ruby
#

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class NinjaslayerTogetter
	NeoSaitamaUrls = %w(
		http://togetter.com/li/73081
		http://togetter.com/li/67523
		http://togetter.com/li/73449
		http://togetter.com/li/73454
		http://togetter.com/li/238464
		http://togetter.com/li/75633
		http://togetter.com/li/73778
		http://togetter.com/li/74478
		http://togetter.com/li/75282
		http://togetter.com/li/78144
		http://togetter.com/li/75597
		http://togetter.com/li/75606
		http://togetter.com/li/75654
		http://togetter.com/li/75756
		http://togetter.com/li/77433
		http://togetter.com/li/77689
		http://togetter.com/li/77702
		http://togetter.com/li/72801
		http://togetter.com/li/77727
		http://togetter.com/li/87853
		http://togetter.com/li/94537
		http://togetter.com/li/98062
		http://togetter.com/li/98696
		http://togetter.com/li/109984
		http://togetter.com/li/111442
		http://togetter.com/li/121054
		http://togetter.com/li/121698
		http://togetter.com/li/81948
		http://togetter.com/li/130014
		http://togetter.com/li/133345
		http://togetter.com/li/136645
		http://togetter.com/li/140221
		http://togetter.com/li/210287
		http://togetter.com/li/241872
		http://togetter.com/li/415632
	)

	def initialize
		@data = Hash.new
	end

	def parse(url)
		doc = Nokogiri::HTML open(url)
		title = doc.xpath('//a[@class="info_title"]/@title').first.value
		tweets = []
		doc.xpath('//div[@class="tweet"]').each do |tweet|
			tweets << tweet.text
		end
		data = @data[url] = {}
		data[:title] = title
		data[:tweets] = tweets
	end

	def page(url)
		parse url
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

		return lines.join "\n"
	end

	def pages(urls)
		pages = []
		urls.each do |url|
			pages << (page url)
		end
		return pages
	end
end



if __FILE__ == $0 then
	nt = NinjaslayerTogetter.new
	NinjaslayerTogetter::NeoSaitamaUrls.each_with_index do |url, i|
		page = nt.page url
		%x(cat << EOP > NeoSaitama_#{sprintf "%02d", i}.rst \n#{page}\nEOP)
	end
end


