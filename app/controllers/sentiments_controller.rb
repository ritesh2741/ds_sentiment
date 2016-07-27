class SentimentsController < ApplicationController
	def analyze_sentiment
		all_comments = Comment.all
		all_comments.each do |x|
			HTTParty.post("http://text-processing.com/api/sentiment/",{:body => { :text => x.title}})
		end

	end
end
