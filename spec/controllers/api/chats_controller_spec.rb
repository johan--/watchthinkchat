require 'spec_helper'

describe Api::ChatsController do
  context "for a visitor" do
    let(:create_user) { create(:user); }
    let(:create_campaign) { create(:campaign); }

    describe "#create" do
      it "should create a new chat room" do
        campaign = create_campaign
        user = create_user
        post :create, :campaign_uid => campaign.uid, :visitor_uid => user.uid
        json_response.should have_key('uid')
      end
    end
  end
end
