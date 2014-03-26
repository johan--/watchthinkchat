require 'spec_helper'

describe Api::MessagesController do
  let(:create_user) { create(:user); }
  let(:create_campaign) { create(:campaign, :campaign_type => "youtube", :video_id => "12345", :permalink => "test"); }

  describe "#create" do
    it "should work" do
      campaign = create_campaign
      visitor = create_user
      operator = create_user
      chat = create(:chat, :campaign_id => campaign.id, :visitor_id => visitor.id, :operator_id => operator.id)

      mock_client = double('client')
      Pusher.stub(:[]).with("chat_#{chat.uid}").and_return(mock_client)
      mock_client.should_receive(:trigger).with('event', { :user_uid => visitor.visitor_uid, :message_type => "user", :message => "Testing" })

      post :create, :chat_uid => chat.uid, :user_uid => visitor.visitor_uid, :message_type => "user", :message => "Testing"
      json_response['success'].should == true
      chat.reload
      chat.visitor_active.should == true
    end
  end
end
