class AppMailer < ActionMailer::Base
  default :from => Project::ADMIN_EMAIL

  def test_email(user)
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end

end
