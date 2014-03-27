require 'spec_helper'

describe Api::VisitorsController do
  let(:create_visitor) { create(:user); }

  it "should create a visitor" do
    post :create, :first_name => "Bob"
    json_response.should have_key('name')
    json_response.should have_key('uid')
    json_response['name'].should == 'Bob'
    json_response['uid'].should_not == nil
    json_response['uid'].should_not == ''
  end

  it "should update a visitor" do
    visitor = create_visitor
    chat = create(:chat, :visitor => visitor)
    # sync_mh method always posts to people first, as MH is smart enough to find an existing record
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=2&person[fb_uid]=123&person[first_name]=#{visitor.first_name}&person[email]=email@email.com").and_return("person" => { "id" => visitor.missionhub_id })
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/contact_assignments?secret=missionhub_token&contact_assignment[person_id]=#{visitor.missionhub_id}&contact_assignment[assigned_to_id]=#{chat.operator.missionhub_id}")

    # from add_label "Challenge Subscribe Self"
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token").and_return("labels" => [{ "name" => "Leader", "id" => 1 }]) # pretend only the Leader label exists
    # it creates the label because only Leader label existed
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token&label[name]=Challenge Subscribe Self").and_return({"label" => {"id" => 2}})
    # next it gets all the labels for that person
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/people/#{visitor.missionhub_id}?secret=missionhub_token&include=organizational_labels").and_return("person" => { "organizational_labels" => [{ "name" => "Leader", "id" => 1 }]})
    # since it's only Leader, it adds Challenge Subscribe Self (id 2)
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/organizational_labels?secret=missionhub_token&organizational_label[person_id]=#{visitor.missionhub_id}&organizational_label[label_id]=2")

    # from add_label "Challenge Subscribe Friend"
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token").and_return("labels" => [{ "name" => "Leader", "id" => 1 }, { "name" => "Challenge Subscribe Self", :id => 2 }])
    # it creates the label
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token&label[name]=Challenge Subscribe Friend").and_return({"label" => {"id" => 3}})
    # next it gets all the labels for that person
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/people/#{visitor.missionhub_id}?secret=missionhub_token&include=organizational_labels").and_return("person" => { "organizational_labels" => [{ "name" => "Leader", "id" => 1 }, { "name" => "Challenge Subscribe Friend", "id" => 2}]})
    # next it adds Challenge Subscribe Friend
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/organizational_labels?secret=missionhub_token&organizational_label[person_id]=#{visitor.missionhub_id}&organizational_label[label_id]=3")

    put :update, :uid => visitor.visitor_uid, :fb_uid => 123, :visitor_email => "email@email.com", :challenge_subscribe_self => true, :challenge_subscribe_friend => "friend@test.com"
  end

  it "should give an error when the visitor ahs no chats" do
    visitor = create_visitor
    put :update, :uid => visitor.visitor_uid, :fb_uid => 123, :visitor_email => "email@email.com", :challenge_subscribe_self => true, :challenge_subscribe_friend => "friend@test.com"
    json_response['error'].should == "chat_not_found"
  end
 end
