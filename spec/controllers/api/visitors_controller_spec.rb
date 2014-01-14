require 'spec_helper'

describe Api::VisitorsController do
  it "should create a visitor" do
    post :create, :first_name => "Bob"
    json_response.should have_key('first_name')
    json_response.should have_key('uid')
    json_response['first_name'].should == 'Bob'
    json_response['uid'].should_not == nil
    json_response['uid'].should_not == ''
  end
end
