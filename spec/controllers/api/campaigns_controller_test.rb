require 'spec_helper'

describe Api::CampaignsController do
  let(:create_user) { create(:user); }
  let(:create_campaign) { create(:campaign, :permalink => "test"); }

  describe "#show" do
    it "should work" do
      campaign = create_campaign
      get :show, :permalink => campaign.permalink
      json_response.should have_key('title')
      json_response.should have_key('type')
      json_response.should have_key('permalink')
    end
  end
end
