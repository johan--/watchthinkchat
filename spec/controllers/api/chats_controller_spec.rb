require 'spec_helper'

describe Api::ChatsController do
  context "for a visitor" do
    let(:create_user) { create(:user, :operator_uid => 'op_uid'); }
    let(:create_campaign) { create(:campaign); }

    describe "#create" do
      it "should create a new chat room" do
        campaign = create_campaign
        visitor = create_user
        operator = create_user

        mock_client = double('client')
        Pusher.stub(:[]).with("operator_#{operator.operator_uid}").and_return(mock_client)
        mock_client.should_receive(:trigger)

        post :create, :campaign_uid => campaign.uid, :visitor_uid => visitor.visitor_uid, :operator_uid => operator.operator_uid
        #puts json_response.inspect
        json_response.should have_key('chat_uid')
        json_response.should have_key('operator')
        json_response['operator']['uid'].should == operator.operator_uid
      end
    end
  end
end
