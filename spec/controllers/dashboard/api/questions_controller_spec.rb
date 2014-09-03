require 'spec_helper'

describe Dashboard::Api::QuestionsController do
  let(:manager) { create(:manager) }
  before do
    sign_in(manager)
    @campaign = create(:campaign)
    manager.campaigns << @campaign
    @survey = create(:engagement_player, campaign: @campaign).survey
    (0..1).each { |_n| create(:question, survey: @survey) }
  end

  context 'with specific campaign' do
    describe '#index' do
      it 'is successful' do
        get :index,
            campaign_id: @campaign.id,
            format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@survey
                           .questions
                           .to_json(include: :options_attributes)))
      end
    end

    describe '#show' do
      it 'is successful' do
        get :show,
            campaign_id: @campaign.id,
            id: @survey.questions.first.id,
            format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@survey
                           .questions
                           .first
                           .to_json(include: :options_attributes)))
      end
    end

    describe '#create' do
      it 'is successful' do
        @question = attributes_for(:question)
        post :create,
             campaign_id: @campaign.id,
             question: @question,
             format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@survey
                           .questions
                           .find(json_response['id'])
                           .to_json(include: :options_attributes)))
      end
    end

    describe '#update' do
      it 'is successful' do
        @question = attributes_for(:question_with_options)
        @old_question = @survey.questions.first
        put :update,
            campaign_id: @campaign.id,
            id: @old_question.id,
            question: @question,
            format: :json
        expect(response).to be_success
        expect(@old_question).to_not be(@survey.questions.first)
      end
    end

    describe '#destroy' do
      it 'is successful' do
        @old_question = @survey.questions.first
        delete :destroy,
               campaign_id: @campaign.id,
               id: @old_question.id,
               format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@old_question.to_json))
      end
    end
  end
end
