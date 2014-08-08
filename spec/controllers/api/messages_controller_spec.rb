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

      allow(Pusher).to receive(:[]).with("chat_#{chat.uid}") { mock_client }
      expect(mock_client).to receive(:trigger).with('event', { :user_uid => visitor.visitor_uid, :message_type => "user", :message => "Testing" })

      post :create, :chat_uid => chat.uid, :user_uid => visitor.visitor_uid, :message_type => "user", :message => "Testing"
      expect(json_response['success']).to be true
      chat.reload
      expect(chat.visitor_active).to be true
    end
  end
end
