require 'sinatra/base'
require 'tilt/erubis' # Fixes a warning

require 'pry'

require './db/setup'
require './lib/all'

class MusicBoxApp < Sinatra::Base
  enable :logging
  enable :sessions

  def current_user
    if session[:logged_in_user_id]
      User.find session[:logged_in_user_id]
    #else
    #  nil
    end
  end

  get "/sign_in" do
    erb :sign_in
  end

  post "/take_sign_in" do
    user = User.where(
      name:     params[:username],
      password: params[:password]
    ).first

    if user
      session[:logged_in_user_id] = user.id
      redirect to("/")
    else
      @message = "Bad username or password"
      #redirect to("/sign_in")
      erb :sign_in
    end
  end

  get "/" do
    erb :home
  end

  def user_logout
   if session.delete[:logged_in_user_id]
   redirect to("/home")
 end

 post "/sign_out" do
   user = User.where(
     name:     params[:username],
     password: params[:password]
     ).first

   if user 
     session.delete[:logged_in_user_id]
     redirect to ("/home")
   else
     @message = "You have been logged out"
     erb :home
   end
 end
end

MusicBoxApp.run! if $PROGRAM_NAME == __FILE__
