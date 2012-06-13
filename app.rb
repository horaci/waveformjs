require 'sinatra'
# require 'sinatra/reloader' if development?
require 'haml'
require 'cgi'
require 'net/https'
require "rmagick"
require 'json'

# require 'sass/plugin/rack'
# use Sass::Plugin::Rack

set :protection, :except => :json_csrf

get '/' do
  haml :index
end

get '/w*' do
  content_type :json

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

  "#{ params[:callback] }(#{ waveform.to_json });"
end
