require 'json'
require 'nokogiri'

module ScrapeHelper
	def tweets_node_set_from_page(page)
		unless page.nil? || page.body.nil?
			doc = nil
			unless page.html?
				doc = Nokogiri::HTML(JSON.parse(page.body)["items_html"])
			else
				doc = page.doc
			end
			node_set = doc.xpath("//li[@data-item-type='tweet']")
			unless node_set.nil?
				return node_set
			end
		end
		[]
	end

	def user_name_from_tweet_node(node)
		node.xpath(".//span[@class='username js-action-profile-name']/b").first.content.to_s rescue nil
	end

	def tweet_body_from_tweet_node(node)
		node.xpath(".//p[@class='js-tweet-text tweet-text']").text.to_s rescue nil
	end

	def scroll_cursor_from_page(page)
		unless page.nil? || page.body.nil?
			return JSON.parse(page.body)["scroll_cursor"] unless page.html?
			page.doc.xpath("//div[@class='stream-container ']/@data-scroll-cursor").to_s rescue nil
		end
	end
end