require 'spec_helper'

describe Api::CampaignsController do
  let(:create_user) { create(:user); }

=begin
  before(:each) do
    Campaign.delete_all
  end
=end

  def create_operator(params = {})
    create(:operator, params.merge(:status => "online"))
  end

  def create_campaign(atts = {})
    create(:campaign, {campaign_type: "youtube", video_id: "12345", password: "password"}.merge(atts));
  end

  describe "#show" do
    it "should work" do
      campaign = create_campaign
      get :show, :uid => campaign.uid
      expect(json_response['title']).to eq(campaign.name)
      expect(json_response['type']).to eq("youtube")
      expect(json_response['permalink']).to eq(campaign.permalink)
      expect(json_response['video_id']).to eq("12345")
    end

    it "should give a 404 if no campaign found" do
      campaign = create_campaign
      get :show, :uid => "bob"
      assert_response 404
    end
  end

  describe "#index" do
    it "should work" do
      @user = create_user
      @user2 = create_user
      campaign = create(:campaign, :admin1 => @user, :campaign_type => "youtube", :video_id => "12345", :password => "password");
      campaign2 = create_campaign
      sign_in @user
      get :index
      expect(json_response.class).to eq(Array)
      expect(json_response.first['title']).to eq(campaign.name)
      expect(json_response.first['type']).to eq("youtube")
      expect(json_response.first['permalink']).to eq(campaign.permalink)
      expect(json_response.first['video_id']).to eq("12345")
    end

    it "should give a 404 if no campaign found" do
      campaign = create_campaign
      get :show, :uid => "bob"
      assert_response 404
    end
  end

  describe "#create" do
    it "should work" do
      operator = create_operator
      sign_in operator
      new_params = {
        title: "#FALLINGPLATES",
        type: "youtube",
        video_id: "KGlx11BxF24",
        permalink: "fallingplates",
        max_chats: 3,
        chat_start: "video_end",
        owner: "426542435",
        description: "Falling plates campaign for Big Break week 3",
        language: "en",
        status: "opened",
        preemptive_chat: true,
        growth_challenge: "operator",
        followup_buttons: [ {
            text: "No",
          }, {
            text: "Yes",
            message_active_chat: "message_active_chat",
            message_no_chat: "message_no_chat"
          }
        ]
      }
      expect(Rest).to receive(:post).with("https://www.missionhub.com/apis/v3/organizations.json?secret=#{ENV['missionhub_token']}&organization[name]=#{new_params[:title]}&organization[terminology]=Organization&organization[show_sub_orgs]=true&organization[status]=active&organization[parent_id]=#{ENV['missionhub_parent']}&include=token").and_return({"organization" => {"id" => 9747,"name" => "FALLINGPLATES","terminology" => "Organization","ancestry" => "8349","show_sub_orgs" => true,"status" => "active","created_at" => "2014-08-06T10:53:21-05:00","updated_at" => "2014-08-06T10:53:21-05:00","token" => "mhtoken"}})
      post :create, new_params
      # response has the message_*_chat params as nils
      new_params[:followup_buttons].first["message_active_chat"] = nil
      new_params[:followup_buttons].first["message_no_chat"] = nil
      # response adds ids
      new_params[:followup_buttons].first["id"] = 1
      new_params[:followup_buttons].second["id"] = 2
      # json_response puts keys to strings
      new_params[:followup_buttons][0] = Hash[new_params[:followup_buttons].first.collect{ |k,v| [k.to_s, v]}]
      new_params[:followup_buttons][1] = Hash[new_params[:followup_buttons].second.collect{ |k,v| [k.to_s, v]}]
      expect(json_response).to eq(Hash[new_params.collect{ |k,v| [k.to_s, v]}].merge("uid" => Campaign.first.uid))
      expect(Campaign.first.missionhub_token).to eq("mhtoken")
    end

    it "should give an error with an invalid create" do
      operator = create_operator
      sign_in operator
      new_params = {
        title: "#FALLINGPLATES",
        type: "youtube",
        video_id: "KGlx11BxF24",
        permalink: "fallingplates",
        max_chats: 3,
        chat_start: "video_end",
        owner: "426542435",
        description: "Falling plates campaign for Big Break week 3",
        language: "en",
        status: "opened",
        preemptive_chat: true,
        growth_challenge: "operator",
        followup_buttons: [ {
            text: "No",
          }, {
            text: "Yes",
            message_active_chat: "message_active_chat",
            message_no_chat: "message_no_chat"
          }
        ]
      }
      expect(Rest).to receive(:post).with("https://www.missionhub.com/apis/v3/organizations.json?secret=#{ENV['missionhub_token']}&organization[name]=#{new_params[:title]}&organization[terminology]=Organization&organization[show_sub_orgs]=true&organization[status]=active&organization[parent_id]=#{ENV['missionhub_parent']}&include=token").and_return({"organization" => {"id" => 9747,"name" => "FALLINGPLATES","terminology" => "Organization","ancestry" => "8349","show_sub_orgs" => true,"status" => "active","created_at" => "2014-08-06T10:53:21-05:00","updated_at" => "2014-08-06T10:53:21-05:00","token" => "mhtoken"}})
      post :create, new_params

      # second post here should give an error because permalink is already taken
      post :create, new_params

      expect(response.code).to eq("406")
      expect(json_response["error"]).to eq([ "Operator Link has already been taken" ])
    end
  end

  describe "#update" do
    it "should require permission" do
      campaign = create_campaign
      operator = create_operator
      sign_in operator

      new_params = {
        followup_buttons: [ {
        } ]
      }
      put :update, new_params.merge(uid: campaign.uid)
      expect(json_response["error"]).to eq("User is not admin")
    end

    it "should validate no empty permalink" do
      operator = create_operator
      campaign = create_campaign(:admin1 => operator)
      sign_in operator

      new_params = {
        permalink: ""
      }
      post :create, new_params
      expect(json_response["error"]).to eq(["Name can't be blank", "Operator Link can't be blank"])
    end

    it "should give an error on invalid followup buttons" do
      operator = create_operator
      campaign = create_campaign(:admin1 => operator)
      sign_in operator

      new_params = {
        followup_buttons: [ {
        } ]
      }
      put :update, new_params.merge(uid: campaign.uid)
      expect(json_response["error"]).to eq(["Followup button 1: Btn text can't be blank"])
    end

    it "should work" do
      operator = create_operator
      campaign = create_campaign(:admin1 => operator)
      sign_in operator

      new_params = {
        title: "#FALLINGPLATES",
        type: "youtube",
        video_id: "KGlx11BxF24",
        permalink: "fallingplates",
        max_chats: 3,
        chat_start: "video_end",
        owner: "426542435",
        description: "Falling plates campaign for Big Break week 3",
        language: "en",
        status: "opened",
        preemptive_chat: true,
        growth_challenge: "operator",
        password: "newpassword",
        followup_buttons: [ {
            text: "No",
          }, {
            text: "I follow another religion",
            message_active_chat: "Thanks for taking time to watch #FallingPlates and for considering Jesus’s call to follow Him. To desire to start following Jesus is a significant step! Its awesome to see you have that desire! Tell us a bit about what’s up? Luv to chat with ya about this stuff in the chat panel on the right :)   ----->",
            message_no_chat: "Thanks for taking time to watch #FallingPlates and for considering Jesus’s call to follow Him. To want to begin to start following Jesus is a significant step. We have a growth adventure that can help u grow after u have asked Christ to come into your life. Heres the place for u to get connected with a friend to grow :)"
          }
        ]
      }

      password_hash_before = campaign.password_hash
      put :update, new_params.merge(uid: campaign.uid)
      # response has the message_*_chat params as nils
      new_params[:followup_buttons].first["message_active_chat"] = nil
      new_params[:followup_buttons].first["message_no_chat"] = nil
      # response adds ids
      new_params[:followup_buttons].first["id"] = 1
      new_params[:followup_buttons].second["id"] = 2
      # json_response puts keys to strings
      new_params[:followup_buttons][0] = Hash[new_params[:followup_buttons].first.collect{ |k,v| [k.to_s, v]}]
      new_params[:followup_buttons][1] = Hash[new_params[:followup_buttons].second.collect{ |k,v| [k.to_s, v]}]
      # password is not passed back
      new_params.delete(:password)
      expect(json_response).to eq(Hash[new_params.collect{ |k,v| [k.to_s, v]}].merge("uid" => campaign.uid))
      expect(campaign.reload.password_hash).not_to eq(password_hash_before)
    end

    it "should work with the query Adam gave me" do
      operator = create_operator
      campaign = create_campaign(:admin1 => operator)
      sign_in operator

      new_params = {
        "chat_start" => nil,
        "title" => "My First Campaign 2",
        "type" => nil,
        "permalink" => "adam",
        "video_id" => "r0dHgtF6qnU",
        "uid" => "32651y6254y5",
        "max_chats" => 5,
        "owner" => nil,
        "description" => nil,
        "language" => "en",
        "status" => "active",
        "followup_buttons" => [],
        "preemptive_chat" => nil,
        "growth_challenge" => "operator"
      }

      password_before = Campaign.last.password_hash
      put :update, new_params.merge(uid: campaign.uid)
      expect(json_response).to eq(Hash[new_params.collect{ |k,v| [k.to_s, v]}].merge("uid" => campaign.uid))
      expect(Campaign.last.password_hash).to eq(password_before)
    end
  end

  describe "#password" do
    it "should not work unless logged in" do
      campaign = create_campaign
      post :password, :uid => campaign.uid, :password => "password"
      assert_response 302
    end

    it "should give invalid password for an operator with the wrong password" do
      campaign = create_campaign
      operator = create_operator
      sign_in operator
      post :password, :uid => campaign.uid, :password => "wrong"
      assert_response 401
      expect(json_response['error']).to eq("Password not valid")
    end

    it "should respond with a 201 when the password is valid" do
      campaign = create_campaign
      operator = create_operator
      sign_in operator
      expect(Rest).to receive(:get).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token").and_return("labels" => [{ "name" => "Leader", "id" => 1 }])
      expect(Rest).to receive(:get).with("https://www.missionhub.com/apis/v3/labels?secret=missionhub_token").and_return("labels" => [{ "name" => "Leader", "id" => 1 }])
      expect(Rest).to receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=4&person[first_name]=#{operator.first_name}&person[email]=#{operator.email}").and_return("person" => { "id" => 1})
      expect(Rest).to receive(:post).with("https://www.missionhub.com/apis/v3/people?secret=missionhub_token&permissions=4&person[first_name]=#{operator.first_name}&person[email]=#{operator.email}").and_return("person" => { "id" => 1})
      allow(Rest).to receive(:get).with("https://www.missionhub.com/apis/v3/people/1?secret=missionhub_token&include=organizational_labels") { {"person" => { "organizational_labels" => [] }} }
      expect(Rest).to receive(:post).with("https://www.missionhub.com/apis/v3/organizational_labels?secret=missionhub_token&organizational_label[person_id]=1&organizational_label[label_id]=1")
      expect(Rest).to receive(:post).with("https://www.missionhub.com/apis/v3/organizational_labels?secret=missionhub_token&organizational_label[person_id]=1&organizational_label[label_id]=1")
      expect {
        post :password, :uid => campaign.uid, :password => "password"
        share_url = json_response["share_url"]
        expect(share_url).to eq(UrlFwd.last.short_url)
        post :password, :uid => campaign.uid, :password => "password" # should only increment UserOperator count by 1 still
        expect(json_response["share_url"]).to eq(share_url)
      }.to change(UserOperator, :count).by(1)
      assert_response 201
    end
  end

  describe "#stats" do
    it "should work" do
      FactoryGirl.reload
      load "spec/support/factories.rb"
      @campaign = create_campaign
      operators = []
      10.times do
        operators << create_operator(operating_campaigns: [@campaign])
      end
      operators.first(5).each do |o|
        create(:chat, operator: o, campaign: @campaign, visitor: create(:visitor), :status => "open")
      end
      operators.first(2).each do |o|
        create(:chat, operator: o, campaign: @campaign, visitor: create(:visitor), :status => "open")
      end
      operators.last(2).each do |o|
        create(:chat, operator: o, campaign: @campaign, visitor: create(:visitor), :status => "closed")
      end
      get :stats, :uid => @campaign.uid
      expect(json_response).to eq({"operators"=>operators.collect{ |o| o.stats_row(@campaign).merge("live_chats" => o.operator_chats.where(campaign: @campaign, status: "open").collect(&:uid)) }, "totals"=>{"total_live_chats"=>7, "total_alltime_chats"=>9, "total_challenge_subscribe_self"=>0, "total_challenge_subscribe_friend"=>0, "total_challenge_friend_accepted"=>0}})
    end
  end
end
