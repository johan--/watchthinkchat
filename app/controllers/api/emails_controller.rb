module Api
  class EmailsController < ApplicationController
    def create
      UserMailer.email(params).deliver
      render json: { success: true }, status: 201
    end
  end
end
