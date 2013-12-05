require 'require_all'
require_all 'twilm_crawl/controllers'
require_all 'twilm_crawl/models'
require_all 'twilm_crawl/helpers'

module TwilmCrawl
	class Crawl
		include ScrapeHelper

		def initialize
			MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
			MongoMapper.database = "netflix"
		end

		def retrieve_tweets
			@bot_controller = (BotController.new).run
		end

		def retrieve_users

		end

		def reset_db
			Bot.stop_all
			User.destroy_all
			Tweet.destroy_all
			Movie.set({year: "NULL"}, :year => 0)
			Movie.set({}, :finished => false, :crawling => false, :bot_id => nil, :tweets_count => 0)
		end
  	end
end