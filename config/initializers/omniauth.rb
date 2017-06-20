OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    #provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']
    provider :facebook, ENV['FB_TEST_ID'], ENV['FB_TEST_SECRET']
end
