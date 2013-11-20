require 'require_all'

module TwilmCrawl
	require_all 'twilm_crawl/models'
	require_all 'twilm_crawl/helpers'

	class Crawl
		include ScrapeHelper

		def initialize
			MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
			MongoMapper.database = "netflix"
		end
  	end
end

crawl = TwilmCrawl::Crawl.new