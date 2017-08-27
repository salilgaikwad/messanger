class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  

  protected
  def configure_permitted_parameters
    registration_params = [:first_name, :last_name, :dob, :publishable_key, :secret_key]
    devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    devise_parameter_sanitizer.permit(:account_update, keys: registration_params)
  end
end