class Campaign
  class EngagementPlayer
    class Option < ActiveRecord::Base
      extend Translatable
      # associations
      belongs_to :question
      has_one :conditional_question, class: 'Question'
      has_many :translations, as: :resource, dependent: :destroy
      # callbacks
      after_save :generate_code, on: :create
      before_destroy :destroy_translations

      # validations
      validates :conditional, presence: true
      validates :title, presence: true
      validates :question, presence: true, on: :update
      validates :conditional_question_id,
                presence: true,
                if: proc { self.skip? }

      # definitions
      enum conditional: [:next, :skip, :finish]
      default_scope { order('created_at ASC') }
      translatable :title

      delegate :campaign, to: :question

      def permalink
        "#{campaign.permalink}/#/o/#{code}"
      end

      protected

      def generate_code
        update_column(:code, Base62.encode(id))
      end

      def destroy_translations
        Translation.where(resource_id: id).destroy_all
      end
    end
  end
end
