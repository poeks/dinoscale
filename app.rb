class App < Sinatra::Base
  
  get '/?' do
    halt redirect "/applications/enabled"
  end
  
  get '/help/?' do
    erb :'help'
  end
  
  get '/applications/enabled/?' do
    erb :'newrelic_enabled'
  end
  
  get '/applications/notenabled/?' do
    erb :'newrelic_notenabled'
  end
  
  get '/applications/other/?' do
    erb :'other'
  end
  
end