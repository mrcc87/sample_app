module SessionsHelper
  # Logs in the given user.
  def log_in user
    session[:user_id] = user.id
  end

  # calls the user remember method, puts the user_id and remember_token in a permanent cookie
  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # sets the current_user variable to the user in the session. if the user was rememberd it logs the user in
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # checks to see if the passed user the the one currentlly logged in
  def current_user? user
    user == current_user
  end

  # checks to see if the user is logged in
  def logged_in?
    !current_user.nil?
  end

  # delets the user remember_digest, the cookie user_id and cookie remember_token
  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # calls the forget method, deletes the user_id from the session and sets the current_user variable to nil
  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user = nil
  end

  # redirects to stored location (or default)
  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # stores the url trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
