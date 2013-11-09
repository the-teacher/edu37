class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = Project::ADMIN_EMAIL
  end
end

Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
