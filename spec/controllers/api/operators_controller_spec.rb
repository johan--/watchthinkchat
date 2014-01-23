require 'spec_helper'

describe Api::OperatorsController do
  let(:create_user) { create(:user, :operator_uid => "op_uid", :profile_pic => "pic" ); }

  it "should get operator info" do
    user = create_user
    get :show, :uid => "op_uid"
    json_response['uid'].should == 'op_uid'
    json_response['name'].should == user.fullname
    json_response['profile_pic'].should == 'pic'
  end
end
