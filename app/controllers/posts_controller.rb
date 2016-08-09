require 'pry'
require 'httparty'
CLIENT_ID = "1015223221932064"
CLIENT_SECRET = "a003571b817d52c393c22b00244d7d91"
class PostsController < ApplicationController
	def index
	end

	def self.fetch_post
		yy= 2015
		mm= 04
		access_token_request = HTTParty.get("https://graph.facebook.com/oauth/access_token?client_id="+CLIENT_ID+"&client_secret="+CLIENT_SECRET+"&grant_type=client_credentials")
		access_token = access_token_request.parsed_response
		for i in 1..15
			if mm <= 11
				feed = req(mm,yy,access_token)
				parse_post(feed)
				mm += 1
			else
				yy = yy+1
				mm = 01
				feed = req(mm,yy,access_token)
				parse_post(feed)
			end
		end
	end

	def self.parse_post(feed)
		feed.each do |x|
			created_time = x['created_time']
			title = x['message']
			fb_id = x['id']
			# begin
			# 	likes = x['likes']['data'].count
			# rescue
			# 	likes = 0
			# end
			begin
				shares = x['shares']['count']
			rescue
				shares = 0
			end
			post = Post.create(title: title,fb_id: fb_id,shares: shares,dob: created_time)
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
		post_initialization(posts)
		posts.each do |p|
			comments = p.comments
			if p.comments.present?
				comments.each do |c|
					if c.sentiment1 == "pos"
						p.pos_sentiment1 += 1
					elsif c.sentiment1 == "neg"
						p.neg_sentiment1 += 1
					else
						p.ntr_sentiment1 += 1
					end
					if c.sentiment2 == "positive"
						p.pos_sentiment2 += 1
					elsif c.sentiment2 == "negative"
						p.neg_sentiment2 += 1
					else
						p.ntr_sentiment2 += 1
					end
					p.save!
				end
			end
			
		end
	end

	def self.post_initialization(posts)
		posts.each do |p|
			p.pos_sentiment1 = 0
			p.neg_sentiment1 = 0
			p.ntr_sentiment1 = 0
			p.pos_sentiment2 = 0
			p.neg_sentiment2 = 0
			p.ntr_sentiment2 = 0
			p.save!
		end
	end

	def self.req(mm,yy,access_token)
		res = HTTParty.get("https://graph.facebook.com/v2.7/UniversityofAkron?"+access_token+"&fields=posts.until("+yy.to_s+"-"+(mm).to_s+"-31).since("+yy.to_s+"-"+mm.to_s+"-01).limit(100){created_time,comments,message,shares}")
		feed = res.first.last.first.last
	end

	def self.like_update
		access_token = "access_token=1015223221932064|bOn_v2I25DvHbFn6nWoVdKgo83Y"
		posts = Post.all
		posts.each do |p|
			res = HTTParty.get("https://graph.facebook.com/v2.7/"+p.fb_id+"/?"+access_token+"&fields=likes.limit(5000),created_time")
			sleep(1)
			begin 
				p.likes = res['likes']['data'].count
			rescue
				p.likes = 0
			end
				p.save!
		end
	end
end
