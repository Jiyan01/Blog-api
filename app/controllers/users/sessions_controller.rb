class Users::SessionsController < Devise::SessionsController
  respond_to :json
  def create
    user = User.find_for_database_authentication(email: params[:email])
    if user && user.valid_password?(params[:password])
      sign_in(user)
      render json: {
        message: 'You are logged in.',
        user: user
      }, status: :ok
    else
      render json: {
        message: 'Invalid email or password'
      }, status: :unauthorized
    end
  end
  
  include Devise::JWT::RevocationStrategies::JTIMatcher

  private

  def respond_with(_resource, _opts = {})
    render json: {
      message: 'You are logged in.',
      user: current_user
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: 'You are logged out.' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
  end
end