class App < Sinatra::Base
    
  get '/?' do
    authorized?
    halt redirect "/applications/enabled"
  end
  
  get '/help/?' do
    authorized?
    erb :'help'
  end
  
  get '/applications/enabled/?' do
    authorized?
    erb :'newrelic_enabled'
  end
  
  get '/applications/notenabled/?' do
    authorized?
    erb :'newrelic_notenabled'
  end
  
  get '/applications/other/?' do
    authorized?
    erb :'other'
  end
  
  # login stuff
  
  get '/login' do
    erb :'account/login'
  end
    
  get '/password_salt/?' do
    if request.xhr?
      account = account_from_email params['email']
      account ? account.password_salt : nil
    end
  end
        
  post '/login/?' do
    account = Account.from_email params['email']
    if account and account.compare_password(params['password'])
        
      session[:accountid] = account.session_id
      puts "Logged in #{account.inspect}".green
      puts "session[:accountid](#{session[:accountid]}) = account.session_id(#{account.session_id})"
      @account = account
      halt redirect '/'
        
    else
      if not account
        flash[:error] = "We can't find your account!"
      elsif params['password_hash'] != account.password_hash 
        flash[:error] = "Your password isn't valid"
      end
      halt redirect '/login'
    end
  end

  get '/logout/?' do
    flash[:notice] = "You are now logged out of your account."
    session.clear
    response.delete_cookie('secure_session')
    redirect '/login'
  end
  
end