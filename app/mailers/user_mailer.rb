class UserMailer < ActionMailer::Base
  default from: "noreply@cru.org"
  
  def email(params)
    #from = "noreply@cru.org"
    from = reply_to = params[:from_name].present? ? "#{params[:from_name]} <#{params[:from]}>" : params[:from]
    logger.info(to: params[:to], reply_to: reply_to, subject: params[:subject], content_type: 'text/plain')
    mail(to: params[:to], from: from, reply_to: reply_to, subject: params[:subject], content_type: 'text/plain') do |format|
      format.text { render text: params[:message] }
    end
  end
end
