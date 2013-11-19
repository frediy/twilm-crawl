class Movie
	include MongoMapper::Document

	attr_accessible :title, :year, :t_count

	key :title, String
	key :year, Integer

	many :tweets
	key :tweets_count, Integer

	# scopes
	scope :with_less_tweets_than, lambda { |max_tweets| where(:tweets_count.lte => max_tweets)}

	#
	# Read Queries
	#
	def self.one_with_less_tweets_than number_of_tweets
		first(:tweets_count.lte => number_of_tweets)
	end

	#
	# Write Queries
	#
	def self.initialize_fields
		set({ tweets_count: { "$exists" => false } }, tweets_count: 0)
	end
end