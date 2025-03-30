Shizit::Application.configure do
  # Code is reloaded on every request. Slow, but perfect for development.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise delivery errors for mailer
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices
  config.active_support.deprecation = :log

  # Don't compress assets
  config.assets.compress = false

  # Show expanded asset loading lines
  config.assets.debug = true

  # Mailer config (Gmail SMTP example)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              "smtp.gmail.com",
    port:                 587,
    domain:               "theshizit.com",
    user_name:            "fritz@theshizit.com",
    password:             ENV["GMAIL_PASSWORD"],
    authentication:       "plain",
    enable_starttls_auto: true
  }
end
