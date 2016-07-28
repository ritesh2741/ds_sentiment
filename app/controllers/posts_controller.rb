require 'pry'
require 'httparty'
CLIENT_ID = "1015223221932064"
CLIENT_SECRET = "a003571b817d52c393c22b00244d7d91"
class PostsController < ApplicationController
	def index
	end

	def self.fetch_post
		access_token_request = HTTParty.get("https://graph.facebook.com/oauth/access_token?client_id="+CLIENT_ID+"&client_secret="+CLIENT_SECRET+"&grant_type=client_credentials")
		access_token = access_token_request.parsed_response
		res = HTTParty.get("https://graph.facebook.com/v2.7/UniversityofAkron?"+access_token+"&fields=posts{message,created_time,comments}")
		feed = res.first.last.first.last
		parse_post(feed)
	end

	def self.parse_post(feed)
		feed.each do |x|
			created_time = x['created_time']
			title = x['message']
			post = Post.create(title: title)
			unless x['comments'] == nil 
				parse_comment(post.id,x)
			end
		end
	end

	def self.parse_comment(post_id,one_feed)
		comments = one_feed['comments']['data']
		comments.each do |x|
			Comment.create(post_id:post_id,text: x['message'])
		end
	end

	def self.update
		comments = Comment.all
		posts = Post.all
		posts.each do |p|
				p.pos_sentiment1 = 0
				p.neg_sentiment1 = 0
				p.ntr_sentiment1 = 0
				p.pos_sentiment2 = 0
				p.neg_sentiment2 = 0
				p.ntr_sentiment2 = 0
				p.save!
		end
		comments.each do |x|
			posts.each do |y|
				if x.post_id == y.id
					if x.sentiment1 == "pos" || "positive"
						y.pos_sentiment1 += 1
					elsif x.sentiment1 == "neg" || "negative"
						y.neg_sentiment1 += 1
					else
						y.ntr_sentiment1 += 1
					end
					if x.sentiment2 == "pos" || "positive"
						y.pos_sentiment2 += 1
					elsif x.sentiment2 == "neg" || "negative"
						y.neg_sentiment2 += 1
					else
						y.ntr_sentiment2 += 1
					end
				y.save!
				end
			end
		end
	end
end
