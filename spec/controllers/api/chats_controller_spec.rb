require 'spec_helper'

describe Api::ChatsController do
  def create_operator(params = {})
    create(:operator, params.merge(:operator => true, :operator_uid => 'op_uid', :status => "online"))
  end

  context do
    #let(:create_operator) { create(:user, :operator => true, :operator_uid => 'op_uid', :status => "online"); }
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
          json_response['error'].should == "campaign_closed"
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

        it "should use the operator with the least number of open chats if the operator requested is full" do
          campaign = create_campaign
          visitor = create_visitor
          operator1 = create_operator
          operator2 = create_operator
          operator3 = create_operator
          # fill up operator 1
          chat1 = create(:chat, operator_id: operator1.id, campaign_id: campaign.id)
          chat2 = create(:chat, operator_id: operator1.id, campaign_id: campaign.id)
          # add one to operator 2
          chat3 = create(:chat, operator_id: operator2.id, campaign_id: campaign.id)

          # operator 3 should be chosen
          mock_client = double('client')
          Pusher.stub(:[]).with("operator_#{operator3.operator_uid}").and_return(mock_client)
          mock_client.should_receive(:trigger)

          post :create, :campaign_uid => campaign.uid, :visitor_uid => visitor.visitor_uid, :operator_uid => operator1.operator_uid
          json_response.should have_key('chat_uid')
          json_response.should have_key('operator')
          json_response['operator']['uid'].should == operator3.operator_uid
        end

        it "should use the operator with the least number of max chats if the operator requested is full and there are multiple operators with no chats" do
          campaign = create_campaign
          visitor = create_visitor
          operator1 = create_operator 
          create(:user_operator, :user_id => operator1.id, :campaign_id => campaign.id)
          operator2 = create_operator 
          create(:user_operator, :user_id => operator2.id, :campaign_id => campaign.id)
          operator3 = create_operator 
          create(:user_operator, :user_id => operator3.id, :campaign_id => campaign.id)
          # 4 to 7 are all free but only 6 hasn't had a chat yet, so 6 should be chosen
          operator4 = create_operator 
          create(:user_operator, :user_id => operator4.id, :campaign_id => campaign.id)
          operator5 = create_operator 
          create(:user_operator, :user_id => operator5.id, :campaign_id => campaign.id)
          operator6 = create_operator 
          create(:user_operator, :user_id => operator6.id, :campaign_id => campaign.id)
          operator7 = create_operator 
          create(:user_operator, :user_id => operator7.id, :campaign_id => campaign.id)
          # fill up operators 1-3
          chat1 = create(:chat, operator_id: operator1.id, campaign_id: campaign.id, :status => "open")
          chat2 = create(:chat, operator_id: operator2.id, campaign_id: campaign.id, :status => "open")
          chat3 = create(:chat, operator_id: operator3.id, campaign_id: campaign.id, :status => "open")
          # add max chats to operators 4,5, and 7
          chat3 = create(:chat, operator_id: operator4.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator5.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator5.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator7.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator7.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator7.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator7.id, campaign_id: campaign.id, :status => "closed")
          chat3 = create(:chat, operator_id: operator7.id, campaign_id: campaign.id, :status => "closed")

          # operator 6 should be chosen
          mock_client = double('client')
          Pusher.stub(:[]).with("operator_#{operator3.operator_uid}").and_return(mock_client)
          mock_client.should_receive(:trigger)

          post :create, :campaign_uid => campaign.uid, :visitor_uid => visitor.visitor_uid, :operator_uid => operator1.operator_uid
          json_response.should have_key('chat_uid')
          json_response.should have_key('operator')
          json_response['operator']['uid'].should == operator6.operator_uid
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
      describe "#show" do
        it "should work" do
          chat = create_chat
          sign_in chat.operator
          chat.messages.create! :user_id => chat.visitor.id, :body => "visitor says hi", :name => chat.visitor.name
          chat.messages.create! :user_id => chat.operator.id, :body => "operator says hi", :name => chat.operator.name
          get :show, :uid => chat.uid
        end
      end

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
          params = { :uid => chat.uid, :visitor_response => "I want to start", :visitor_name => chat.visitor.name, :visitor_email => "new@email.com", :calltoaction => "something", :notes => "notes here" }
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=2&person[first_name]=#{chat.visitor.first_name}&person[email]=new@email.com").and_return("person" => {"id" => mh_id})
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/contact_assignments?secret=missionhub_token&contact_assignment[person_id]=#{mh_id}&contact_assignment[assigned_to_id]=#{chat.operator.missionhub_id}")
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/contact_assignments?secret=missionhub_token&contact_assignment[person_id]=#{mh_id}&contact_assignment[assigned_to_id]=#{chat.operator_whose_link.missionhub_id}")
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/followup_comments", {:secret=>chat.campaign.missionhub_token, :followup_comment => { :contact_id => chat.visitor.missionhub_id, :commenter_id => chat.operator.missionhub_id, :comment => chat.build_comment(params) }}).and_return("followup_comment" => [{"id" => 1}])
          post :collect_stats, params
          chat.visitor.reload.email.should == "new@email.com"
        end
        it "should handle wonky emails that get passed in by the client every so often" do
          chat = create_chat
          sign_in chat.operator
          mh_id = chat.visitor.missionhub_id
          params = { :uid => chat.uid, :visitor_response => "I want to start", :visitor_name => chat.visitor.name, :visitor_email => "{&quot;message_type&quot;=&gt;&quot;fbemail&quot;}", :calltoaction => "something", :notes => "notes here" }
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=2&person[first_name]=#{chat.visitor.first_name}&person[email]=#{chat.visitor.email}").and_return("person" => {"id" => mh_id})
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/contact_assignments?secret=missionhub_token&contact_assignment[person_id]=#{mh_id}&contact_assignment[assigned_to_id]=#{chat.operator.missionhub_id}")
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/contact_assignments?secret=missionhub_token&contact_assignment[person_id]=#{mh_id}&contact_assignment[assigned_to_id]=#{chat.operator_whose_link.missionhub_id}")
          Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/followup_comments", {:secret=>chat.campaign.missionhub_token, :followup_comment => { :contact_id => chat.visitor.missionhub_id, :commenter_id => chat.operator.missionhub_id, :comment => chat.build_comment(params) }}).and_return("followup_comment" => [{"id" => 1}])
          post :collect_stats, params
        end
      end
    end
  end
end
