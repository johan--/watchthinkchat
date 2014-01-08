require 'spec_helper'

describe Api::ChatsController do
  context "for a visitor" do
    let(:create_user) { create(:user); puts "HERE1" }

    describe "#create" do
      it "should create a new chat room" do
        post :create, :campaign_id => "12345"
        json_response.should have_key('title')
        json_response.should have_key('type')
        json_response.should have_key('url')
      end
    end
  end
end
