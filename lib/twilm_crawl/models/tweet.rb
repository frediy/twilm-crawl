require 'mongo_mapper'

class Tweet
	include MongoMapper::Document

	attr_accessible :body, :user_id, :movie_id

	key :body, String

	belongs_to :user
	belongs_to :movie

	#
	# Validations
	#
	validates_presence_of :body
	validates_presence_of :user
end