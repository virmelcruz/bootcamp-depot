class SessionsController < ApplicationController
	skip_before_action :authorize, except: [:destroy]
	def new
		
	end

	def create
		user = User.find_by(name: params[:name])
		if user.try(:authenticate, params[:password]) #authenticate is has access to has_secure_password if (user && user,authenticate(params[:password]))
			session[:user_id] = user.id #session for user
			redirect_to admin_url
		else
			redirect_to login_url, alert: "Invalid user/password combination" #alert, notice = flash messages
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to store_index_url, notice: "Logged out"
	end
end