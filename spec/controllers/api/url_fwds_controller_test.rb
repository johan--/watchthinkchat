require 'spec_helper'

describe Api::UrlFwdsController do
  describe "#create" do
    it "should work" do
      post :create, :full_url => "/asdf1234"
      json_response['short_url'].should_not be_nil
    end
  end
end
