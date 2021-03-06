class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :answered_dilemmas, :avatar, :bio])

    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :answered_dilemmas, :avatar, :bio])
  end

  def default_url_options
  { host: ENV["DOMAIN"] || "localhost:3000" }
  end

#  def after_sign_out_path_for(_resource_or_scope)
#    root_path
#  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
