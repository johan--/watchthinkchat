class UserMailer < ActionMailer::Base
  default from: "noreply@cru.org"
  
  def email(params)
    if params[:from_name].present?
      from = "noreply@cru.org <#{params[:from_name]}>"
    else
      from = "noreply@cru.org"
    end
    mail(to: params[:to], from: from, reply_to: params[:from], subject: params[:subject], content_type: 'text/plain') do |format|
      format.text { render text: params[:message] }
    end
  end
end
