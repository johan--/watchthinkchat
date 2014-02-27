class UserMailer < ActionMailer::Base
  default from: "noreply@cru.org"
  
  def email(params)
    from = "noreply@cru.org"
    reply_to = params[:from_name] ? "#{params[:from_name]} <#{params[:from]}>" : params[:from]
    logger.info(to: params[:to], reply_to: reply_to, subject: params[:subject], content_type: 'text/plain')
    puts(to: params[:to], reply_to: reply_to, subject: params[:subject], content_type: 'text/plain')
    mail(to: params[:to], reply_to: reply_to, subject: params[:subject], content_type: 'text/plain') do |format|
      format.text { render text: params[:message] }
    end
  end
end
