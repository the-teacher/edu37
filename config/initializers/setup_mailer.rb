ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.yandex.ru",
  :port                 => 587,
  :domain               => "yandex.ru",
  :user_name            => "JosephStalinTester",
  :password             => "000000000000000",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = Project::ROOT_DOMAIN
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

