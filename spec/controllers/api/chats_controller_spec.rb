require 'spec_helper'

puts "HERE0"

describe Api::ChatsController do
  context "for a visitor" do
    let(:create_user) { create(:user); puts "HERE1" }

    describe "#create" do
      it "should create a new chat room" do
        create_user
      end
    end
  end
end
