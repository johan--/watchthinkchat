require 'spec_helper'

describe Api::EmailsController do
  describe "#create" do
    it "should work" do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        post :create, to: 'to@email.com', from: 'from@email.com', from_name: 'from_name', message: "message\nAnother\n\nLine", subject: 'subject'
      end
      email = ActionMailer::Base.deliveries.last
      assert_equal "to@email.com", email.header['To'].to_s
      assert_equal "from_name <noreply@cru.org>", email.header['From'].to_s
      assert_equal "subject", email.subject
      assert_match /message/, email.body.to_s
      assert_equal "from_name <from@email.com>", email.header['Reply-To'].to_s
    end
  end
end
