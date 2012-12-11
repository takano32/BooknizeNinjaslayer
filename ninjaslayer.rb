#!/usr/bin/env ruby
#

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class NinjaslayerTogetter
	# http://togetter.com/li/73867
	# Neo-Saitama in flames
	# Kyoto: Hell on earth
	# Ninjaslayer Never Die
	NeoSaitamaInFlames = %w(
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

	KyotoHellOnEarth = %w(
		http://togetter.com/li/143666
		http://togetter.com/li/146008
		http://togetter.com/li/147645
		http://togetter.com/li/155087
		http://togetter.com/li/164719
		http://togetter.com/li/172686
		http://togetter.com/li/174643
		http://togetter.com/li/179249
		http://togetter.com/li/188112
		http://togetter.com/li/196268
		http://togetter.com/li/201494
		http://togetter.com/li/204755
		http://togetter.com/li/210449
		http://togetter.com/li/211642
		http://togetter.com/li/220060
		http://togetter.com/li/221373
		http://togetter.com/li/226989
		http://togetter.com/li/232419
		http://togetter.com/li/246960
		http://togetter.com/li/249170
		http://togetter.com/li/255221
		http://togetter.com/li/263048
		http://togetter.com/li/271957
		http://togetter.com/li/273541
		http://togetter.com/li/287333
		http://togetter.com/li/304545
		http://togetter.com/li/314866
		http://togetter.com/li/318236
		http://togetter.com/li/320675
		http://togetter.com/li/336889
		http://togetter.com/li/347801
		http://togetter.com/li/357672

	)

	NinjaslayerNeverDie = %w(
		http://togetter.com/li/235346
		http://togetter.com/li/266554
		http://togetter.com/li/279174
		http://togetter.com/li/288760
		http://togetter.com/li/373252
		http://togetter.com/li/378622
		http://togetter.com/li/383030
		http://togetter.com/li/396587
		http://togetter.com/li/402001
		http://togetter.com/li/417978
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
	NinjaslayerTogetter::NeoSaitamaInFlames.each_with_index do |url, i|
		page = nt.page url
		%x(cat << EOP > NeoSaitamaInFlames_#{sprintf "%02d", i}.rst \n#{page}\nEOP)
	end
	NinjaslayerTogetter::KyotoHellOnEarth.each_with_index do |url, i|
		page = nt.page url
		%x(cat << EOP > KyotoHellOnEarth_#{sprintf "%02d", i}.rst \n#{page}\nEOP)
	end
	NinjaslayerTogetter::NinjaslayerNeverDie.each_with_index do |url, i|
		page = nt.page url
		%x(cat << EOP > NinjaslayerNeverDie_#{sprintf "%02d", i}.rst \n#{page}\nEOP)
	end
end


