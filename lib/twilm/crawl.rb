# require 'twilm/crawl/version'
require 'require_all'

require 'anemone'
require 'mongo'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "netflix"

module Twilm
	require_all 'models'

	MAX_TWEETS_PER_MOVIE = 200

	class Crawl
		def initialize
			Movie.initialize_fields
		end

		def run
			Anemone.crawl("https://testmctestmc:averylongpasswordaboutahorse@twitter.com/search?q=the%20dark%20knight%202012&src=typd") do |anemone|
				anemone.on_every_page do |page|
					tweets_node_set_from_page(page).each do |node|
						puts user_name_from_tweet_node(node)
						puts tweet_body_from_tweet_node(node)
						puts "-"
					end
					# mongo: store tweets
				end

				anemone.focus_crawl do |page|
					# if movie tweet count >= MAX_TWEETS_PER_MOVIE
						# grab html for scroll and generate url
					# else
						# mongo: get new movie to crawl
					[]
				end
			end
		end

		def uncrawled_movie
			Movie.one_with_less_tweets_than MAX_TWEETS_PER_MOVIE
		end

		#
		# Scraping
		#
		def tweets_node_set_from_page(page)
			page.doc.xpath("//li[@data-item-type='tweet']") rescue nil
		end

		def user_name_from_tweet_node(node)
			node.xpath(".//span[@class='username js-action-profile-name']/b").first.content.to_s rescue nil
		end

		def tweet_body_from_tweet_node(node)
			node.xpath(".//p[@class='js-tweet-text tweet-text']/text()").to_s rescue nil
		end
  	end
end

crawl = Twilm::Crawl.new
crawl.run