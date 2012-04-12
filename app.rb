class App < Sinatra::Base
  
  get '/?' do
    erb :'index'
  end
  
  get '/list/?' do
    erb :'list'
  end
  
end