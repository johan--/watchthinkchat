require 'spec_helper'

describe Api::ChatsController do
  context do
    let(:create_operator) { create(:user, :operator => true, :operator_uid => 'op_uid', :status => "online"); }
    let(:create_visitor) { create(:user); }
    let(:create_campaign) { create(:campaign); }
    let(:create_chat) { create(:chat, :campaign => create_campaign, :operator => create_operator, :visitor => create_visitor, :operator_whose_link => create_operator); }

    context "for a visitor" do
      describe "#create" do
        it "should not create a new chat for a closed campaign" do
          campaign = create_campaign
          visitor = create_visitor
          operator = create_operator

          campaign.update_attribute :status, "closed"

          post :create, :campaign_uid => campaign.uid, :visitor_uid => visitor.visitor_uid, :operator_uid => operator.operator_uid
          json_response.should have_key('error')
          json_response['error'].should == "Sorry, campaign is closed"
        end

        it "should create a new chat" do
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
          mh_id = chat.visitor.missionhub_id
          params = { :uid => chat.uid, :visitor_response => "I want to start", :visitor_name => chat.visitor.name, :visitor_email => chat.visitor.email, :calltoaction => "something", :notes => "notes here" }
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=2&person[first_name]=#{chat.visitor.first_name}&person[last_name]=#{chat.visitor.last_name}&person[email]=#{chat.visitor.email}").and_return("person" => {"id" => mh_id})
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/followup_comments?secret=missionhub_token&followup_comment[contact_id]=#{mh_id}&followup_comment[commenter_id]=#{chat.operator.missionhub_id}&followup_comment[comment]=#{chat.build_comment(params)}").and_return("followup_comment" => [{"id" => 1}])
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/contact_assignments?secret=missionhub_token&contact_assignment[person_id]=#{chat.visitor.missionhub_id}&contact_assignment[assigned_to_id]=#{chat.operator.missionhub_id}")
          post :collect_stats, params
        end
      end
    end
  end
end
