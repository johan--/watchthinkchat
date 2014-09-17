require 'spec_helper'

describe Dashboard::Api::TranslationsController do
  let(:translator) { create(:translator) }
  let(:translation) { Translation.first }
  before do
    sign_in(translator)
    @campaign = create(:campaign)
    translator.campaigns << @campaign
    @locale = create(:locale)
    AvailableLocale.create(campaign: @campaign, locale: @locale)
    translator.permissions
              .where(resource: @campaign)
              .first
              .update(state: Permission.states[:translator],
                      locale: @locale)
    @survey = create(:engagement_player, campaign: @campaign).survey
    (0..1).each { |_n| create(:question, survey: @survey) }
  end
  describe '#show' do
    context 'translation does not exist' do
      before do
        get :show,
            campaign_id: @campaign.id,
            locale_id: @locale.id,
            id: translation.id,
            format: 'json'
      end

      it 'creates a translation' do
        expect(Translation.exists?(resource: @campaign,
                                   locale: @locale,
                                   field: translation.field)).to eq(true)
      end

      it 'returns a translation' do
        expect(response).to be_success
        expect(json_response)
          .to eq(JSON.parse(Translation.find_by(resource: @campaign,
                                                locale: @locale,
                                                field: translation.field)
                                       .to_json))
      end
    end
    context 'translation exists' do
      before do
        @old_translation = Translation.create(resource: @campaign,
                                              locale: @locale,
                                              field: translation.field)
        get :show,
            campaign_id: @campaign.id,
            locale_id: @locale.id,
            id: translation.id,
            format: 'json'
      end
      it 'returns a translation' do
        expect(response).to be_success
        expect(json_response['id'])
          .to eq(@old_translation.id)
      end
    end
  end
  describe '#update' do
    before do
      @translation = Translation.create(resource: @campaign,
                                        locale: @locale,
                                        field: translation.field)
      @content = Faker::Hacker.verb
    end
    it 'is successful' do
      put :update,
          campaign_id: @campaign.id,
          locale_id: @locale.id,
          id: translation.id,
          translation: { content: @content },
          format: 'json'
      expect(json_response['content'])
        .to eq(@content)
    end
  end

  describe '#destroy' do
    before do
      @translation = Translation.create(resource: @campaign,
                                        locale: @locale,
                                        field: translation.field)
    end
    it 'is successful' do
      delete :destroy,
             campaign_id: @campaign.id,
             locale_id: @locale.id,
             id: translation.id,
             format: 'json'
      expect(response).to be_success
      expect(json_response)
        .to eq(JSON.parse(@translation.to_json))
    end
  end
end
