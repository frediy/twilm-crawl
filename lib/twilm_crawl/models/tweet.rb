class Tweet
	include MongoMapper::Document
	key :body, String

	belongs_to :user
	belongs_to :movie

	#
	# Validations
	#
	validates_presence_of :body
	validates_presence_of :user
end