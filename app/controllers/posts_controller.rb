require 'pry'
require 'httparty'
CLIENT_ID = "1015223221932064"
CLIENT_SECRET = "a003571b817d52c393c22b00244d7d91"
class PostsController < ApplicationController
	def index
	end

	def fetch_post
	access_token_request = HTTParty.get("https://graph.facebook.com/oauth/access_token?client_id="+CLIENT_ID+"&client_secret="+CLIENT_SECRET+"&grant_type=client_credentials")
	access_token = access_token_request.parsed_response
	res = HTTParty.get("https://graph.facebook.com/v2.7/UniversityofAkron?"+access_token+"&fields=posts{message,created_time,comments}")
	feed = res.first.last.first.last
	# binding.pry
	# parse_post(feed)
	end

	def parse_post(feed)
		binding.pry
		created_time = feed[0]['created_time']
		title = feed[0]['message']
		post = Post.create(title: title)
		parse_comment(post.id,feed)

	end

	def parse_comment(post_id,feed)
		comments = feed[0]['comments']['data']
		comments.each do |x|
			Comment.create(post_id:post_id,title: x['message'])
		end
	end
end
