require 'sinatra'
require 'haml'
require 'pry'

use Rack::Session::Cookie, secret: ENV['SECRET_TOKEN']

# --- PSEUDOCODE FOR RUBY/SINATRA VERSION --- #

=begin
  
DONE - A method to populate the board

DONE - A method to select a random letter from the starting letters array and to remove it from the array

DONE - A method to insert a new tile randomly (see benchmarking file in /)

A post route that accepts user input

  /?direction=up&position=

A check to see if user input is valid (any tiles in that area)

A move function

A check after move to see if colors need to change

A check to see if array of insertable tiles is empty = i.e., game over!

A scoring method

=end

get '/' do
  haml :index
end

post '/' do
  haml :index
end
