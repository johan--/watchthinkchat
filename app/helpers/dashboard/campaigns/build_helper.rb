module Dashboard
  module Campaigns
    module BuildHelper
      def step_class(step)
        return 'list-group-item active' if wizard_path == wizard_path(step)
        return 'list-group-item list-group-item-success' if past_step?(step)
        'list-group-item disabled'
      end
    end
  end
end
