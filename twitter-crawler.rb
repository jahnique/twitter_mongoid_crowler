# encoding: UTF-8
require 'mongoid'
require 'mongoid_geospatial'
require 'pry'
require 'tweetstream'

Mongoid.load!('mongoid.yml', :development)

class Tweet
  include Mongoid::Document
  include Mongoid::Geospatial

  field :created_at, type: Time, default: Time.now
  field :text, type: String
  field :location, type: Point, spatial: true
end

TweetStream.configure do |config|
  config.consumer_key       = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret    = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token        = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_TOKEN_SECRET']
  config.auth_method        = :oauth
end

berlin_box_twitter = [13.10770, 52.4561, 13.45462, 52.5244]
#berlin_box_twitter = [-180, -90, 180, 90]
TweetStream::Client.new.locations(berlin_box_twitter) do |status|
  Tweet.new(text: status.text) do |tweet|
    tweet.location = status.geo.coordinates
  end.save!
puts status.text
end
