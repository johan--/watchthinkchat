require 'spec_helper'

describe Api::CampaignsController do
  let(:create_user) { create(:user); }
  let(:create_campaign) { create(:campaign, :campaign_type => "youtube", :video_id => "12345", :permalink => "test"); }

  describe "#show" do
    it "should work" do
      campaign = create_campaign
      get :show, :permalink => campaign.permalink
      json_response['title'].should == campaign.name
      json_response['type'].should == "youtube"
      json_response['permalink'].should == "test"
      json_response['video_id'].should == "12345"
    end

    it "should give a 404 if no campaign found" do
      campaign = create_campaign
      get :show, :permalink => "bob"
      assert_response 404
    end
  end
end
