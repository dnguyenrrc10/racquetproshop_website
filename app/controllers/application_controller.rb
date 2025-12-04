class ApplicationController < ActionController::Base
  before_action :initialize_cart
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def initialize_cart
    session[:cart] ||= {} # { "product_id" => quantity }
  end

  def current_cart
    session[:cart]
  end

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'You are not authorized to access that page.'
    end
  end

  protected

  def configure_permitted_parameters
    extra_attrs = [
      :name,
      :address,
      :city,
      :province,
      :postal_code
    ]


    # sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_attrs)

    # account update (edit profile)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_attrs)
  end
end
