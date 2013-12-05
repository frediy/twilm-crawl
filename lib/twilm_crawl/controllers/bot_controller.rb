require 'anemone'
require_all 'twilm_crawl/models'
require_all 'twilm_crawl/helpers'

class BotController
	include ScrapeHelper

	def initialize
		load_bots
	end

	def run
		@bots.each do |bot|
			bot.stop
		end

		@bots.each do |bot|
			run_bot(bot)
		end
	end

	def run_bot(bot)
		unless bot.running?
			bot.threads = []
			uncrawled_movie = Movie.uncrawled
			bot.movie = uncrawled_movie
			uncrawled_movie.crawling!
			uri = uncrawled_movie.search_uris.first
			bot.threads << Thread.new do
				bot.start
				crawl_uri_with_bot(uri, bot)
			end
			bot.threads.each(&:join)
		end

	end

	def stop
		@bots.each do |bot|
			stop_bot(bot)
		end
	end

	def stop_bot(bot)
		bot.threads.each { |thread| thread.kill }
		bot.stop
	end

	private

	def load_bots
		@bots = [Bot.where(:running => false).first]
	end

	def crawl_uri_with_bot(uri, bot)
		# p "crawl_uri_with_bot(#{uri}, #{bot})"
		Anemone.crawl(search_url_with_initiate(uri, bot)) do |anemone|

			# extract tweet and user
			anemone.on_every_page do |page|
				unless page.nil?
					c = 0
					tweets_node_set_from_page(page).each do |node|
						user = User.find_or_create_by_name(user_name_from_tweet_node(node))
						tweet = Tweet.find_or_create_by_body_and_user_id_and_movie_id(tweet_body_from_tweet_node(node), user.id)
						bot.movie.add_tweet(tweet)
						c += 1
					end
					# puts "on_every_page > tweets extracted > #{c}"
					# puts "#{bot.username}"
					# puts "html? #{page.html?}"
					# puts "doc? #{!page.doc.nil?}"
					# puts "body? #{!page.body.nil?}"
				end
			end

			# extract scroll url or crawl next movie
			anemone.focus_crawl do |page|
				# puts 'focus_crawl'
				# puts "#{bot.username}"
				# puts "html? #{page.html?}"
				# puts "doc? #{!page.doc.nil?}"
				# puts "body? #{!page.body.nil?}"
				scroll_cursor = scroll_cursor_from_page(page)
				p scroll_cursor

				if bot.movie.tweets_count <= Movie::MAX_TWEETS_PER_MOVIE && !scroll_cursor.blank? && !(bot.scroll_cursor == scroll_cursor)
					# extract scroll url
					# puts "crawl #{scroll_url(uri, bot, scroll_cursor)}"
					bot.scroll_cursor = scroll_cursor
					[URI(scroll_url(uri, bot, scroll_cursor))]
				else
					# crawl next movie
					bot.movie.finish_crawl!
					uncrawled_movie = Movie.uncrawled
					uri = uncrawled_movie.search_uris.first
					bot.crawl_movie(uncrawled_movie)
					# puts "crawl #{search_url(uri, bot)}"
					[URI(search_url(uri, bot))]
				end
			end

			# callback to run bot again on uncrawled movie
			anemone.after_crawl do
				puts 'after_crawl'
				uncrawled_movie = Movie.uncrawled
				uri = uncrawled_movie.search_uris.first
				crawl_uri_with_bot(uri, bot)
			end
		end
	end

	def search_url_with_initiate(uri, bot)
		"https://#{bot.username}:#{bot.password}@twitter.com/search?q=#{uri}&src=typd"
	end

	def search_url(uri, bot)
		"https://twitter.com/search?q=#{uri}&src=typd"
	end

	def scroll_url(uri, bot, scroll_cursor)
		"https://twitter.com/i/search/timeline?q=#{uri}&src=typd&include_available_features=1&include_entities=1&last_note_ts=0&scroll_cursor=#{scroll_cursor}"
	end
end