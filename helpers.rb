module Helpers
  
  def authorized?
    
    puts "Session: #{session.inspect}".yellow
    puts "SessionID: #{session[:accountid]}".yellow
    
    can_access = true
    if current_account.class != Account
      can_access = false
    end
    
    puts "Current User: #{current_account.inspect}"
    puts "Can Access? #{can_access}"
    
    if not can_access
      puts "Not logged in!"
      flash[:error] = "You are not authorized to access #{request.path}!"
      halt redirect '/login'
    else
      can_access
    end
  end
  
  def current_account
    if session[:accountid]
      @account = Account.from_session_id(session[:accountid])
    else
      false
    end
  end
  
  
  
end