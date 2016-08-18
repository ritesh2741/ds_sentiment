# ds_sentiment

COPY posts TO '/tmp/posts' DELIMITER ',' CSV HEADER;

PostsController.fetch_post
SentimentsController.analyze_sentiment
SentimentsController.sentiment_analyzer
PostsController.update
