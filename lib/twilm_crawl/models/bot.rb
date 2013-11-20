require 'anemone'

class Bot
	include MongoMapper::Document

	key :username, String
	key :password, String
	key :running, Boolean, :default => false

	#
	# Validations
	#
	validates_presence_of :username
	validates_presence_of :password

	def initialize(username, password)
		@threads = []
		@running = false
	end

	def crawl_uri uri
		Proc.new {
			# Anemone.crawl("https://#{@username}:#{@password}@twitter.com/search?q=#{uri}&src=typd") do |anemone|
			# 	anemone.on_every_page do |page|
			# 		tweets_node_set_from_page(page).each do |node|
			# 			puts user_name_from_tweet_node(node)
			# 			puts tweet_body_from_tweet_node(node)
			# 			puts "-"
			# 		end
			# 		# mongo: store tweets
			# 	end

			# 	anemone.focus_crawl do |page|
			# 		# if movie tweet count >= MAX_TWEETS_PER_MOVIE
			# 			# grab html for scroll and generate url
			# 		# else
			# 			# mongo: get new movie to crawl
			# 		[]
			# 	end
			# end
		}
	end

	def run
		# @running = true
		# @movie = Movie.uncrawled
		# @movie.search_uris.each do |uri|
		# 	@threads << Thread.new do
		# 		crawl_uri(uri)
		# 	end
		# end
	end

	def stop
		# @running = false
	end
end