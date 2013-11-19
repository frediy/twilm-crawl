class Tweet
	include MongoMapper::Document
	key :body, String

	belongs_to :user
	belongs_to :movie
end