class UserMailer < ActionMailer::Base
  default from: "noreply@cru.org"
  
  def email(params)
    if params[:from_name].present?
      from = "noreply@cru.org <#{params[:from]}>"
    end
    mail(to: params[:to], from: from, message: params[:message].html_safe, reply_to: params[:from], subject: params[:subject], content_type: 'text/plain') do |format|
      format.text
    end
  end
end
