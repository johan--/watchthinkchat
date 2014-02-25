class Api::MessagesController < ApplicationController
  def create
    UserMailer.email(params).deliver
  end
end
