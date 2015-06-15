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

  get "/change_password" do
    @password = current_user.password
    @username = current_user.name
    erb :change_password
  end

  post "/update_password" do
    current_user.update(password: params["new_password"])
    redirect to("/change_password")
  end

  post "/update_username" do
    current_user.update(name: params["new_username"])
    redirect to("/change_password")
  end

end

MusicBoxApp.run! if $PROGRAM_NAME == __FILE__
