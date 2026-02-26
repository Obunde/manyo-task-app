class SessionsController < ApplicationController
  # Allow access to the login page even if not logged in!
  skip_before_action :require_login, only: [:new, :create]
  # Redirect logged-in users away from the login page
  before_action :redirect_if_logged_in, only: [:new]

  def new
    # Just renders the login form (new.html.erb)
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    # has_secure_password provides the .authenticate method
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: "I have logged in"
    else
      flash.now[:danger] = "Your email address or password is incorrect"
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: "logged out"
  end

  private

  def redirect_if_logged_in
    if logged_in?
      redirect_to tasks_path
    end
  end
end