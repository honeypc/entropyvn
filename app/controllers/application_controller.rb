class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Pundit authorization
  include Pundit::Authorization

  # Configure permitted parameters for Devise
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  # Handle authorization failures from Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  # Switch locale and redirect back
  def switch_locale
    locale = params[:locale].to_sym

    if I18n.available_locales.include?(locale)
      session[:locale] = locale.to_s
      current_user&.update(locale: locale.to_s) if user_signed_in?
      I18n.locale = locale
    end

    redirect_back(fallback_location: root_path)
  end

  private

  # Set locale from params, user preference, or HTTP headers
  def set_locale
    # Priority: URL param > user stored preference > HTTP Accept-Language header > default
    if params[:locale].present? && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
      # Store in user model if logged in
      current_user&.update(locale: params[:locale]) if user_signed_in?
    end

    locale = session[:locale] ||
             (current_user.locale if user_signed_in? && current_user.respond_to?(:locale)) ||
             extract_locale_from_accept_language_header ||
             I18n.default_locale

    I18n.locale = locale
  end

  # Extract locale from HTTP Accept-Language header
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first&.to_sym
  end

  def user_json(user, include_api_token: false)
    data = user.as_json(
      only: %i[id email name role_id created_at updated_at],
      methods: [:avatar_url],
      include: [] # Prevent circular reference by excluding associations
    )
    data["api_token"] = user.api_token if include_api_token
    data
  end

  def user_not_authorized
    if request.format.json?
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    else
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
