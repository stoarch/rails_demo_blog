class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  NotAuthorized = Class.new(StandardError)
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_error_page(status: 404, text: 'Not found')
  end

  rescue_from ApplicationController::NotAuthorized do |exception|
    flash[:alert] = exception.message
    render_error_page(status: 403, text: 'Forbidden.' )
  end

  def current_author_id
    current_user&.author&.id
  end

  def after_sign_up_path_for(resource)
    new_author_path(resource)
  end


  private

  def render_error_page(status:, text:, template: 'errors/routing')
    respond_to do |format|
      format.json { render json: {errors: [message: "#{status} #{text}"]}, status: status }
      format.html { render template: template, status: status, layout: false }
      format.any  { head status }
    end
  end
end
