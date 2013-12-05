require 'mongo_mapper'
require 'anemone'

class Bot
	include MongoMapper::Document

	attr_accessible :username, :password, :movie_id
	attr_accessor :scroll_cursor

	key :username, String
	key :password, String

	key :running, Boolean, :default => false
	one :movie

	#
	# Validations
	#
	validates_presence_of :username
	validates_presence_of :password


	#
	# Instance methods
	#
	def initialize
		@threads = []
	end

	def one_thread_left?
		@threads.each.map { |t| t.alive? }.one?
	end

	def start
		self.running = true
		save!
	end

	def stop
		self.running = false
		self.movie = nil
		save!
	end

	def threads=(threads)
		@threads = threads
	end

	def threads
		@threads
	end

	def crawl_movie(movie)
		self.movie.crawling = false
		self.movie.bot = nil
		self.movie.save!
		self.movie = movie
		self.movie.bot = self
		save!
	end

	#
	# Class methods
	#
	def self.stop_all
		Bot.all.each do |bot|
			bot.stop
		end
	end
end