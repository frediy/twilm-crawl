class Tweet
	include MongoMapper::Document
	key :name

	many :tweets
end