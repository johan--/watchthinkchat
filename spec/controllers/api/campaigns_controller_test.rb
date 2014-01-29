require 'spec_helper'

describe Api::CampaignsController do
  let(:create_user) { create(:user); }
  let(:create_operator) { create(:user, :operator => true, "operator_uid" => "ouid" ); }
  let(:create_campaign) { create(:campaign, :campaign_type => "youtube", :video_id => "12345", :permalink => "test", :password => "password"); }

  describe "#show" do
    it "should work" do
      campaign = create_campaign
      get :show, :uid => campaign.uid
      json_response['title'].should == campaign.name
      json_response['type'].should == "youtube"
      json_response['permalink'].should == "test"
      json_response['video_id'].should == "12345"
    end

    it "should give a 404 if no campaign found" do
      campaign = create_campaign
      get :show, :uid => "bob"
      assert_response 404
    end
  end

  describe "#password" do
    it "should not work unless logged in" do
      campaign = create_campaign
      post :password, :uid => campaign.uid, :password => "password"
      assert_response 401
      json_response['error'].should == "Operator access required for this operator"
    end

    it "should give invalid password for an operator with the wrong password" do
      campaign = create_campaign
      operator = create_operator
      sign_in operator
      post :password, :uid => campaign.uid, :password => "wrong"
      assert_response 401
      json_response['error'].should == "Password not valid"
    end

    it "should respond with a 201 when the password is valid" do
      campaign = create_campaign
      operator = create_operator
      sign_in operator
      post :password, :uid => campaign.uid, :password => "password"
      assert_response 201
    end
  end
end
