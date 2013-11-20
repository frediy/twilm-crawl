# require 'twilm/crawl/version'
require 'require_all'

require 'anemone'
require 'mongo'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "netflix"

module TwilmCrawl
	require_all 'models'

	class Crawl
		def initialize
		end
  	end
end

crawl = TwilmCrawl::Crawl.new