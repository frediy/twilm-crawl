require 'mongo_mapper'

class Movie
	include MongoMapper::Document

	MAX_TWEETS_PER_MOVIE = 200

	attr_accessible :title, :year, :tweets_count, :crawling, :bot_id

	key :netflix_id, String
	key :title, String
	key :year, Integer

	many :tweets
	key :tweets_count, Integer, :default => 0

	belongs_to :bot
	key :crawling, Boolean, :default => false # needs_crawling, crawling or complete
	key :finished, Boolean, :default => false

	#
	# Validations
	#
	validates_presence_of :title
	validates_presence_of :year
	validates_presence_of :tweets_count
	validates_inclusion_of :crawling, :in => [true, false]

	#
	# Scopes
	#
	scope :with_less_tweets_than, lambda { |max_tweets| where(:tweets_count.lte => max_tweets)}

	def uri_title_year
		URI::encode("#{title} #{year}")
	end

	def uri_title_movie
		URI::encode("#{title} movie")
	end

	def uri_title_film
		URI::encode("#{title} film")
	end

	def search_uris
		[uri_title_year, uri_title_movie, uri_title_film]
	end

	def crawling?
		crawling
	end

	def needs_crawling?
		tweets_count < MAX_TWEETS_PER_MOVIE
	end

	def complete?
		!crawling? && !needs_crawling?
	end

	def crawling!
		self.crawling = true
		save!
	end

	def stop_crawling!
		self.crawling = false
		save!
	end

	def finish_crawl!
		stop_crawling!
		self.finished = true
		save!
	end

	def add_tweet(tweet)
		self.tweets << tweet
		self.tweets_count += 1
		save!
	end

	#
	# Read Queries
	#
	# def self.one_with_less_tweets_than number_of_tweets
	# 	first(:tweets_count.lte => number_of_tweets)
	# end
	def self.uncrawled
		first(:finished => false, :crawling => false, :tweets_count.lte => MAX_TWEETS_PER_MOVIE)
	end

	#
	# Write Queries
	#
	def self.initialize_fields
		set({ :tweets_count => { "$exists" => false } }, :tweets_count => 0)
		set({ :crawling => { "$exists" => false } }, :crawling => false)
	end
end