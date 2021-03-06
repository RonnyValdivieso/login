class OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		generic_callback("facebook")
	end
	def generic_callback(provider)
		@identity = Identity.find_for_oauth(env["omniauth.auth"])

		@user = @identity.user || current_user

		if @user.nil?
			@user = User.create(email: @identity.email || "")
			@identity.update_attribute(:user_id, @user.id)
		end

		if @user.persisted?
			@identity.update_attribute(:user_id, @user.id)

			@user = FormUser.find(@user.id)

			sign_in_and_redirect @user, event: :authentication
			set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
		else
			session["devise.#{provider}_data"] = env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end

	def setup
	    request.env['omniauth.strategy'].options['scope'] = flash[:scope] || request.env['omniauth.strategy'].options['scope']
	    render :text => "Setup complete.", :status => 404
	end
end