require 'sinatra'
require 'haml'
require 'gon-sinatra'
require 'pry'

require 'mongoid'
require 'mongoid_geospatial'

Sinatra::register Gon::Sinatra

Mongoid.load!('mongoid.yml', :development)

class Tweet
  include Mongoid::Document
  include Mongoid::Geospatial

  field :created_at, type: Time, default: Time.now
  field :text, type: String
  field :location, type: Point, spatial: true
end

get '/' do
  gon.tweets = Tweet.all.to_a
  haml :index
end
