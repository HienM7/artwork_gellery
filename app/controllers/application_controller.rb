class ApplicationController < ActionController::Base
	layout :layout_by_resource
	
	before_action :update_allowed_parameters, if: :devise_controller?

	protected

	def update_allowed_parameters
		devise_parameter_sanitizer.permit(:sign_up){|u| u.permit(:username, :password, :email, :credit_card, :point)}
		# devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :credit_card, :password, :current_password)}
	end
	
	private
	
	def ensure_admin_user!
    redirect_to root_path unless current_user && current_user.is_admin?
	end

  def ensure_login
    if !current_user
      redirect_to new_user_session_path
      return
    end
	end

	def layout_by_resource
		log_act = [
			[:user, 'new'],
			[:user, 'cancel']
		]
		if devise_controller? && log_act.include?([resource_name, action_name])
			"auth"
		else
			"application"
		end
	end
end
