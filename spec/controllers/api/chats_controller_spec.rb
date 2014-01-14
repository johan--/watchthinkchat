require 'spec_helper'

describe Api::ChatsController do
  context "for a visitor" do
    let(:create_user) { create(:user); }
    let(:create_campaign) { create(:campaign); }

    describe "#create" do
      it "should create a new chat room" do
        campaign = create_campaign
        visitor = create_user
        operator = create_user
        post :create, :campaign_permalink => campaign.permalink, :visitor_uid => visitor.visitor_uid, :operator_uid => operator.uid
        #puts json_response.inspect
        json_response.should have_key('chat_uid')
        json_response.should have_key('operator')
      end
    end
  end
end
