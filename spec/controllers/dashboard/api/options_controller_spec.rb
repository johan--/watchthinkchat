require 'spec_helper'

describe Dashboard::Api::OptionsController do
  let(:manager) { create(:manager) }
  before do
    sign_in(manager)
    @campaign = create(:campaign)
    manager.campaigns << @campaign
    manager.permissions.where(resource: @campaign).first.owner!
    @survey = @campaign.survey
    (0..1).each do
      question = create(:question, survey: @survey)
      (0..1).each do
        create(:option, question: question)
      end
    end
    @question = @survey.questions.first
    @option = @question.options.first
  end

  context 'with specific question' do
    describe '#index' do
      it 'is successful' do
        get :index,
            campaign_id: @campaign.id,
            question_id: @question.id,
            format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@question.options.to_json))
      end
    end

    describe '#show' do
      it 'is successful' do
        get :show,
            campaign_id: @campaign.id,
            question_id: @question.id,
            id: @option.id,
            format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@option.to_json))
      end
    end

    describe '#create' do
      it 'is successful' do
        @option = attributes_for(:option)
        post :create,
             campaign_id: @campaign.id,
             question_id: @question.id,
             option: @option,
             format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(
              JSON.parse(@question.options.find(json_response['id']).to_json))
      end
    end

    describe '#update' do
      it 'is successful' do
        @option = attributes_for(:option)
        @old_option = @question.options.first
        put :update,
            campaign_id: @campaign.id,
            question_id: @question.id,
            id: @old_option.id,
            question: @option,
            format: :json
        expect(response).to be_success
        expect(@old_option).to_not be(@question.options.first)
      end
    end

    describe '#destroy' do
      it 'is successful' do
        @old_option = @question.options.first
        delete :destroy,
               campaign_id: @campaign.id,
               question_id: @question.id,
               id: @old_option.id,
               format: :json
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(@old_option.to_json))
      end
    end
  end
end
