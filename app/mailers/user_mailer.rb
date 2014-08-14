class UserMailer < ActionMailer::Base
  default from: 'noreply@cru.org'

  def email(params)
    if params[:from_name].present?
      from = "\"#{params[:from_name]}\" <noreply@cru.org>"
      reply_to = "\"#{params[:from_name]}\" <#{params[:from]}>"
    else
      from = 'noreply@cru.org'
      reply_to params[:from]
    end

    mail(to: params[:to],
         from: from,
         reply_to: reply_to,
         subject: params[:subject],
         content_type: 'text/plain') do |format|
      format.text { render text: params[:message] }
    end
  end
end
