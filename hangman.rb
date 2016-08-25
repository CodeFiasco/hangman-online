require 'sinatra'

# Use cookies for session. Set expiration for 1 day
use Rack::Session::Pool, :expire_after => 86400

get '/' do
  if session[:word] == nil
    session[:word] = get_word
    session[:wrong_letters] = []
    session[:right_letters] = []
    session[:end?] = false
  end

  erb :index
end

post '/' do
  if session[:word].include?(params[:letter])
    session[:right_letters] << params[:letter] unless session[:right_letters].include?(params[:letter])
  else
    session[:wrong_letters] << params[:letter] unless session[:wrong_letters].include?(params[:letter])
  end

  if (session[:wrong_letters].length == 6) || (session[:word].split('') - session[:right_letters]).empty?
    session[:end?] = true
  end

  erb :index
end

get '/new' do
  session[:word] = nil
  redirect to('/')
end

private
# Returns a random word from the file "5desk.txt"
def get_word
  # Get all the lines in the file
  words = File.readlines "5desk.txt"
  word = ""

  # Keep reading a random line in the file until there's a valid word
  until word.length <= 12 && word.length >= 5
    word = words[rand(words.length)].chomp
  end

  # Return word with lower case letters
  word.downcase
end
