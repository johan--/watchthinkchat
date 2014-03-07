class UserMailer < ActionMailer::Base
  default from: "noreply@cru.org"
  
  def email(params)
    from = params[:from_name].present? ? "\"#{params[:from_name]}\" <noreply@cru.org>" : "noreply@cru.org"
    reply_to = params[:from_name].present? ? "\"#{params[:from_name]}\" <#{params[:from]}>" : params[:from]
    #puts(to: params[:to], from: from, reply_to: reply_to, subject: params[:subject], content_type: 'text/plain')
    mail(to: params[:to], from: from, reply_to: reply_to, subject: params[:subject], content_type: 'text/plain') do |format|
      format.text { render text: params[:message] }
    end
  end
end
