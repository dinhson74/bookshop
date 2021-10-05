class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :address, :phone, :birthday, :password,:password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :address, :phone, :birthday])
  end
end
