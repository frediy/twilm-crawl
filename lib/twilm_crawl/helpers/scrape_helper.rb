module ScrapeHelper
	def self.tweets_node_set_from_page(page)
		page.doc.xpath("//li[@data-item-type='tweet']") rescue nil
	end

	def self.user_name_from_tweet_node(node)
		node.xpath(".//span[@class='username js-action-profile-name']/b").first.content.to_s rescue nil
	end

	def self.tweet_body_from_tweet_node(node)
		node.xpath(".//p[@class='js-tweet-text tweet-text']/text()").to_s rescue nil
	end
end