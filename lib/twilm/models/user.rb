require 'mongo_mapper'

class User
	include MongoMapper::Document
	key :name

	many :tweets

	#
	# Validations
	#
	validates_presence_of :name
end