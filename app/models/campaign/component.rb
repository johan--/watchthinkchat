class Campaign
  class Component < ActiveRecord::Base
    self.abstract_class = true

    extend Translatable
    # associations
    belongs_to :campaign
    has_many :translations, as: :resource, dependent: :destroy

    # validations
    validates :campaign, presence: true
    validates :enabled, inclusion: [true, false]

    # callbacks
    before_destroy :destroy_associations

    protected

    def destroy_associations
      Translation.where(resource_id: id).destroy_all
    end
  end
end
