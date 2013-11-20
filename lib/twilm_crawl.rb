VERSION = "0.0.1"

require 'require_all'

require 'anemone'
require 'mongo'
require 'mongo_mapper'

module TwilmCrawl
	require_all 'twilm_crawl/models'

	class Crawl
		def initialize
			MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
			MongoMapper.database = "netflix"
		end
  	end
end

crawl = TwilmCrawl::Crawl.new