require 'spec_helper'

describe Api::ChatsController do
  context do
    let(:create_operator) { create(:user, :operator => true, :operator_uid => 'op_uid', :status => "online"); }
    let(:create_visitor) { create(:user); }
    let(:create_campaign) { create(:campaign); }
    let(:create_chat) { create(:chat, :operator => create_operator, :visitor => create_visitor); }

    context "for a visitor" do
      describe "#create" do
        it "should create a new chat room" do
          campaign = create_campaign
          visitor = create_visitor
          operator = create_operator

          mock_client = double('client')
          Pusher.stub(:[]).with("operator_#{operator.operator_uid}").and_return(mock_client)
          mock_client.should_receive(:trigger)

          post :create, :campaign_uid => campaign.uid, :visitor_uid => visitor.visitor_uid, :operator_uid => operator.operator_uid
          json_response.should have_key('chat_uid')
          json_response.should have_key('operator')
          json_response['operator']['uid'].should == operator.operator_uid
        end
      end
      describe "#destroy" do
        it "should not work" do
          chat = create_chat
          delete :destroy, :uid => chat.uid
          json_response.should have_key('error')
        end
      end
    end

    context "for an operator" do
      describe "#destory" do
        it "should work" do
          chat = create_chat
          sign_in chat.operator
          mock_client = double('client')
          Pusher.stub(:[]).with("chat_#{chat.uid}").and_return(mock_client)
          mock_client.should_receive(:trigger)

          delete :destroy, :uid => chat.uid
          chat.reload
          chat.status.should == "closed"
        end
      end
      describe "#collect_stats" do
        it "should work" do
          chat = create_chat
          sign_in chat.operator
          mock_person = double('person', :id => chat.visitor.missionhub_id)
          mock_people = double('people', :length => 1, :first => mock_person)
          MissionHub::Person.should_receive(:find).and_return(mock_people)
          MissionHub::FollowupComment.should_receive(:create).with(contact_id: mock_person.id, commenter_id: chat.operator.missionhub_id, comment: "notes here")
          post :collect_stats, :uid => chat.uid, :visitor_response => "I want to start", :visitor_name => "Steve", :visitor_email => "test@test.com", :calltoaction => "something", :notes => "notes here"
        end
      end
    end
  end
end
