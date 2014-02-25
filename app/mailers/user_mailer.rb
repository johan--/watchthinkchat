class UserMailer < ActionMailer::Base
  default from: "noreply@cru.org"
  
  def email(params)
    if params[:from_name].present?
      from = "noreply@cru.org <#{params[:from]}>"
    end
    mail(to: params[:to], from: from, message: params[:message], reply_to: params[:from])
  end
end
