Shizit::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ERROR] ",
  :sender_address => '"Error" <error@theshizit.com>',
  :exception_recipients => ['fritz@theshizit.com']