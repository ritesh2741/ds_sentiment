require 'unirest'

class SentimentsController < ApplicationController
	def self.analyze_sentiment
		all_comments = Comment.all
		response1 = []
		all_comments.each do |x|
			if x.sentiment1 == nil 
				response = HTTParty.post("http://text-processing.com/api/sentiment/",{:body => { :text => x.text}})
				if response.code == 200 || 202
					result = response['label']
				else
					result = "error"
				end
				x.sentiment1 = result
				x.save!
			end
		end
	end	

	def self.sentiment_analyzer
		all_comments = Comment.all
		response2 = []
		all_comments.each do |x|
			if x.sentiment2 == nil
				response = Unirest.post("https://twinword-sentiment-analysis.p.mashape.com/analyze/",headers:{"X-Mashape-Key" => "OAn5Rkp6YDmshgJac2WpbraChJygp11JW0ejsnIZDapJceWrVM","Content-Type" => "application/x-www-form-urlencoded","Accept" => "application/json"},parameters:{"text" => x.text})
				if response.code == 200 || 202
					result = response.body['type']
				else
					result = "error"
				end
				x.sentiment2 = result
				x.save!
			end
		end
	end

	def twitter_sentiments
	end

end
