Shizit::Application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: "[ERROR] ",
      sender_address: %{"Error" <error@theshizit.com>},
      exception_recipients: %w[fritz@theshizit.com]
    }
