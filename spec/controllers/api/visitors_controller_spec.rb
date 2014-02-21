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
    # mh gets
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token").and_return("labels" => [{ "name" => "Leader", "id" => 1 }])
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token").and_return("labels" => [{ "name" => "Leader", "id" => 1 }])
    Rest.should_receive(:get).with("https://www.missionhub.com/apis/v3/people/1?secret=missionhub_token&include=organizational_labels").and_return("person" => { "organizational_labels" => [{ "name" => "Leader", "id" => 1 }]})
    # mh posts
    # should create the two labels
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token&label[name]=Challenge Subscribe Self").and_return({"label" => {"id" => 1}})
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token&label[name]=Challenge Subscribe Friend").and_return({"label" => {"id" => 1}})
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=2&person[first_name]=#{visitor.first_name}&person[last_name]=#{visitor.last_name}&person[email]=email@email.com").and_return({"person" => {"id" => 1}})
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/organizational_labels?secret=missionhub_token&organizational_label[person_id]=1&organizational_label[label_id]=1")
    Rest.should_receive(:post).with("https://www.missionhub.com/apis/v3/organizational_labels?secret=missionhub_token&organizational_label[person_id]=1&organizational_label[label_id]=1")

    put :update, :visitor_uid => visitor.visitor_uid, :fb_uid => 123, :visitor_email => "email@email.com", :challenge_subscribe_self => true, :challenge_subscribe_friend => true
  end
end
