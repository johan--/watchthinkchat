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
        post :create, :campaign_uid => campaign.uid, :visitor_uid => visitor.uid, :operator_uid => operator.uid
        json_response.should have_key('chat_uid')
      end
    end
  end
end
