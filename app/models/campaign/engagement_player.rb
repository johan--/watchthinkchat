class Campaign
  class EngagementPlayer < ActiveRecord::Base
    extend Translatable
    # associations
    belongs_to :campaign
    has_many :translations, as: :resource, dependent: :destroy

    # callbacks
    before_destroy :destroy_associations

    # validations
    validates :media_link, presence: true
    validates :campaign, presence: true
    validates :enabled, inclusion: [true, false]

    # definitions
    translatable :media_link

    protected

    def destroy_associations
      Translation.where(resource_id: id).destroy_all
    end
  end
end
