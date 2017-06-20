class SessionsController < ApplicationController
    def create
        user = User.from_omniauth(env["omniauth.auth"])
        session[:user_id] = user.id

        Rails.logger.debug("--- Creating a User Session with #{user.id} ---")
        redirect_to root_url
    end

    def destroy
        Rails.logger.debug("--- Destroying User session #{session[:user_id]} ---")
        session[:user_id] = nil
        redirect_to root_url
    end
end
