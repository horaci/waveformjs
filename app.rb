require 'sinatra'
require 'haml'
require 'cgi'
require 'net/https'
require 'RMagick'
require 'json'
require 'coffee-script'
require 'dalli'
require 'sass'
require 'compass'

set :cache, Dalli::Client.new
set :enable_cache, true
set :protection, :except => :json_csrf

module Haml::Filters::Example
  include Haml::Filters::Base
  def render(text)
    %[<script class="example">#{text}</script>]
  end
end

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, { :format => :html5, :ugly => true }
  set :sass, Compass.sass_engine_options
end

get '/' do
  haml :index
end

get '/application.css' do
  sass :application
end

get '/waveform.js' do
  content_type "text/javascript"
  coffee :waveform
end

get '/w*' do
  content_type :json

  waveform = memcache_fetch params[:url] do
    waveform = []

    image = Magick::Image.read(params[:url]).first
    image.crop!(0, 0, image.columns, image.rows / 2)
    image.rotate!(90)

    columns = image.columns

    image.each_pixel do |pixel, c, r|
      if waveform.length <= r && (pixel.opacity == 0 || c == columns - 1)
        waveform << c / columns.to_f
      end
    end

    waveform
  end

  if params[:callback]
    "#{ params[:callback] }(#{ waveform.to_json });"
  else
    waveform.to_json
  end
end

def memcache_fetch(key)
  settings.cache.get(key) || begin
    value = yield
    settings.cache.set(key, value)
    value
  end
end
