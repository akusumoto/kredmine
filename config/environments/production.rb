RedmineApp::Application.configure do
  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.logger = nil
  config.active_support.deprecation = :log
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 25,
    :domain => "smtp.gmail.com",
    :authentication => :login,
    :user_name => "itukiyu02@gmail.com",
    :password => "pasuta4649",
  }
  config.action_mailer.perform_deliveries = true
end
